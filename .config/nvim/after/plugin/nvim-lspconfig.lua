-- LSP servers. Per-server settings live in after/lsp/<name>.lua.
vim.lsp.enable({
  'ansiblels', 'asm_lsp', 'astro', 'awk_ls', 'bashls', 'biome', 'clangd',
  'clojure_lsp', 'cmake', 'cssls', 'cue', 'dartls', 'diagnosticls', 'dockerls',
  'elixirls', 'eslint', 'expert', 'flow', 'fsautocomplete', 'gopls', 'groovyls',
  'helm_ls', 'hls', 'html', 'jdtls', 'jsonls', 'kotlin_lsp', 'lemminx',
  'lua_ls', 'marksman', 'metals', 'omnisharp', 'perlnavigator', 'powershell_es',
  'pylsp', 'pyright', 'rubocop', 'ruff', 'rust_analyzer', 'scheme_langserver',
  'solargraph', 'svelte', 'tailwindcss', 'vala_ls', 'vtsls', 'vue_ls',
  'yamlls', 'zls',
})

-- Enables LSP completion.
vim.opt.completeopt = { 'menuone', 'noselect', 'popup' }
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end
})

-- Also complete on word characters, not just trigger characters.
vim.api.nvim_create_autocmd('InsertCharPre', {
  group = vim.api.nvim_create_augroup('UserLspCompletion', {}),
  callback = function()
    if vim.fn.pumvisible() ~= 0 or not vim.v.char:match('[%w_]') then
      return
    end
    if next(vim.lsp.get_clients({ bufnr = 0, method = 'textDocument/completion' })) then
      vim.schedule(vim.lsp.completion.get)
    end
  end
})

-- Give the doc popup free space at borders.
local doc_min_width = 40
local doc_margin = 1

-- Nothing fires for that window, so poll while the menu is up.
local doc_timer = assert(vim.uv.new_timer())

-- Free rectangle by the menu; bottom means it grows upward.
local function doc_area(pum)
  local rows = vim.o.lines - 2
  local edge = pum.col + pum.width + (pum.scrollbar and 1 or 0)
  local right, left = vim.o.columns - edge, pum.col

  -- Beside the menu, on whichever side has the most room.
  if math.max(right, left) >= doc_min_width then
    return {
      row = doc_margin,
      col = right >= left and edge + doc_margin or doc_margin,
      width = math.max(right, left) - 2 * doc_margin,
      height = rows - 2 * doc_margin,
    }
  end

  -- Too narrow either side: full width under or over the menu.
  local width = vim.o.columns - 2 * doc_margin
  local under = pum.row + pum.height + doc_margin
  local below = rows - under - doc_margin
  local above = pum.row - 2 * doc_margin

  if below >= above then
    return { row = under, col = doc_margin, width = width, height = below }
  end
  return { bottom = pum.row - doc_margin, col = doc_margin, width = width, height = above }
end

local function doc_place()
  if vim.fn.pumvisible() == 0 then
    doc_timer:stop()
    return
  end

  local win = vim.fn.complete_info().preview_winid
  local pum = vim.fn.pum_getpos()
  if not (win and win > 0 and vim.api.nvim_win_is_valid(win)) or vim.tbl_isempty(pum) then
    return
  end

  local area = doc_area(pum)
  if area.width < 1 or area.height < 1 then return end

  -- Width first: how tall the text is depends on where its lines wrap.
  if vim.api.nvim_win_get_width(win) ~= area.width then
    vim.api.nvim_win_set_width(win, area.width)
  end

  local height = math.max(1, math.min(area.height, vim.api.nvim_win_text_height(win, {}).all))
  local row = area.bottom and (area.bottom - height) or area.row

  local have = vim.api.nvim_win_get_config(win)
  if have.row ~= row or have.col ~= area.col or have.height ~= height then
    vim.api.nvim_win_set_config(win, {
      relative = 'editor',
      anchor = 'NW',
      row = row,
      col = area.col,
      width = area.width,
      height = height,
    })
  end
end

vim.api.nvim_create_autocmd('CompleteChanged', {
  group = vim.api.nvim_create_augroup('UserLspCompletionDoc', {}),
  callback = function()
    doc_timer:stop()
    doc_timer:start(50, 50, vim.schedule_wrap(doc_place))
  end
})

-- Diagnostics and docs where the mouse rests. Needs MouseMove.
vim.o.mousemoveevent = true

local hover_delay = 2000
local hover_timer = assert(vim.uv.new_timer())

--- @type { win: integer, winid: integer, line: integer, col: integer }?
local hover = nil

-- Our float, or nil. Forgets one Neovim already closed.
local function hover_current()
  if hover and not vim.api.nvim_win_is_valid(hover.win) then
    hover = nil
  end
  return hover
end

local function hover_close()
  local current = hover_current()
  if current then
    vim.api.nvim_win_close(current.win, true)
  end
  hover = nil
end

-- Diagnostics covering one position, as markdown lines.
local function hover_diagnostics(buf, row, col)
  local lines = {}
  for _, d in ipairs(vim.diagnostic.get(buf, { lnum = row })) do
    -- A zero-width diagnostic still covers the cell it points at.
    local last = d.lnum == d.end_lnum and math.max(d.end_col, d.col + 1) or d.end_col
    local starts = d.lnum < row or col >= d.col
    local ends = d.end_lnum > row or col < last
    if starts and ends then
      local severity = vim.diagnostic.severity[d.severity]
      local source = d.source and (' ' .. d.source) or ''
      lines[#lines + 1] = ('**%s**%s'):format(severity, source)
      vim.list_extend(lines, vim.split(d.message, '\n', { trimempty = true }))
      lines[#lines + 1] = ''
    end
  end
  return lines
end

local function hover_show()
  if hover_current() or vim.fn.pumvisible() ~= 0 then return end

  local pos = vim.fn.getmousepos()
  if pos.line == 0 or pos.column == 0 then return end

  local buf = vim.api.nvim_win_get_buf(pos.winid)
  local row, col = pos.line - 1, pos.column - 1
  local diagnostics = hover_diagnostics(buf, row, col)

  -- Show the float from whatever we have, once the hover request is in.
  local function present(docs)
    local lines = vim.list_extend({}, diagnostics)
    if #lines > 0 and #docs > 0 then
      lines[#lines] = '---'
    end
    vim.list_extend(lines, docs)
    if vim.tbl_isempty(lines) then return end

    -- Drop it if the mouse moved while the request was in flight.
    local now = vim.fn.getmousepos()
    if now.winid ~= pos.winid or now.line ~= pos.line or now.column ~= pos.column then
      return
    end

    vim.api.nvim_win_call(pos.winid, function()
      local _, win = vim.lsp.util.open_floating_preview(lines, 'markdown', {
        relative = 'mouse', focusable = false,
      })
      hover = { win = win, winid = pos.winid, line = pos.line, col = pos.column }
    end)
  end

  local clients = vim.lsp.get_clients({ bufnr = buf, method = 'textDocument/hover' })
  if vim.tbl_isempty(clients) then
    present({})
    return
  end

  for _, client in ipairs(clients) do
    local params = {
      textDocument = vim.lsp.util.make_text_document_params(buf),
      position = {
        line = row,
        character = vim.lsp.util.character_offset(buf, row, col, client.offset_encoding),
      },
    }

    client:request('textDocument/hover', params, function(_, result)
      if hover_current() then return end
      local contents = result and result.contents
      present(contents and vim.lsp.util.convert_input_to_markdown_lines(contents) or {})
    end, buf)
  end
end

vim.keymap.set({ 'n', 'i' }, '<MouseMove>', function()
  local pos = vim.fn.getmousepos()
  local current = hover_current()
  if current and (pos.winid ~= current.winid
    or pos.line ~= current.line or pos.column ~= current.col) then
    hover_close()
  end
  hover_timer:stop()
  hover_timer:start(hover_delay, 0, vim.schedule_wrap(hover_show))
end, { desc = 'Hover documentation after a pause' })
