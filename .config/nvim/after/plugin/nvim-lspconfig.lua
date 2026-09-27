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

-- Float that shows LSP hover docs; the next K reuses it.
local hover_win

-- Float width as a share of its window; a drag or resize changes it.
local hover_ratio = 0.4

-- Full-height float on the right edge of window src.
-- getwininfo() height leaves out the winbar, unlike nvim_win_get_height.
local function hover_config(src)
  local info = vim.fn.getwininfo(src)[1]
  local w = math.floor(info.width * hover_ratio + 0.5)
  return {
    relative = 'win',
    win = src,
    style = 'minimal',
    border = 'none',
    width = w,
    height = info.height,
    row = 0,
    col = info.width - w
  }
end

-- Show markdown lines in the float of window src; returns the buffer.
local function show_hover(src, lines)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = 'markdown'
  vim.keymap.set('n', 'q', '<Cmd>close<CR>', { buffer = buf })

  -- Reuse an open float, and move it to the source window.
  if hover_win and vim.api.nvim_win_is_valid(hover_win) then
    vim.api.nvim_win_set_buf(hover_win, buf)
    vim.api.nvim_win_set_config(hover_win, hover_config(src))
  else
    hover_win = vim.api.nvim_open_win(buf, false, hover_config(src))
  end
  vim.wo[hover_win].wrap = true
  vim.wo[hover_win].conceallevel = 2
  -- An empty sign column gives two columns of left padding.
  vim.wo[hover_win].signcolumn = 'yes'
  -- Keep the float colour when it is not the current window.
  vim.wo[hover_win].winhighlight = 'NormalNC:NormalFloat,SignColumn:NormalFloat'
  return buf
end

-- Show LSP hover docs in a float on the right side.
local function hover_right()
  local src = vim.api.nvim_get_current_win()
  local params = function(client)
    return vim.lsp.util.make_position_params(0, client.offset_encoding)
  end
  vim.lsp.buf_request_all(0, 'textDocument/hover', params, function(results)
    local lines = {}
    for _, res in pairs(results) do
      local contents = res.result and res.result.contents
      if contents then
        -- The blank line stops '---' from making a markdown heading.
        if #lines > 0 then vim.list_extend(lines, { '', '---' }) end
        local md = vim.lsp.util.convert_input_to_markdown_lines(contents)
        vim.list_extend(lines, md)
      end
    end
    if #lines == 0 then
      vim.notify('No hover information')
      return
    end
    show_hover(src, lines)
  end)
end

-- Highlight groups for the diagnostic headers, by severity.
local diagnostic_ns = vim.api.nvim_create_namespace('diagnostics_right')
local severity_hl = { 'DiagnosticError', 'DiagnosticWarn', 'DiagnosticInfo', 'DiagnosticHint' }

-- Show diagnostics of the cursor line in the hover float.
local function diagnostics_right()
  local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
  local lines, heads = {}, {}
  for _, d in ipairs(vim.diagnostic.get(0, { lnum = lnum })) do
    -- A blank line; '---' under text makes a markdown heading.
    if #lines > 0 then table.insert(lines, '') end
    local head = vim.diagnostic.severity[d.severity]
    if d.source then head = head .. ' ' .. d.source end
    if d.code then head = head .. ' ' .. d.code end
    table.insert(lines, head)
    heads[#lines] = d.severity
    vim.list_extend(lines, vim.split(d.message, '\n'))
  end
  if #lines == 0 then
    vim.notify('No diagnostics')
    return
  end
  local buf = show_hover(vim.api.nvim_get_current_win(), lines)
  for row, severity in pairs(heads) do
    vim.api.nvim_buf_set_extmark(buf, diagnostic_ns, row - 1, 0, {
      end_col = #lines[row],
      hl_group = severity_hl[severity]
    })
  end
end

-- Replace the default diagnostic float keys.
for _, lhs in ipairs({ '<C-w>d', '<C-w><C-d>' }) do
  vim.keymap.set('n', lhs, diagnostics_right, { desc = 'Diagnostics in float' })
end

-- Hover float buffer that shows docs of a completion item.
local completion_buf

-- Show docs of the selected LSP completion item in the hover float.
vim.api.nvim_create_autocmd('CompleteChanged', {
  callback = function(ev)
    local word = vim.v.event.completed_item.word
    local lsp = vim.tbl_get(vim.v.event.completed_item, 'user_data', 'nvim', 'lsp')
    local client = lsp and vim.lsp.get_client_by_id(lsp.client_id)
    if not client then return end
    local src = vim.api.nvim_get_current_win()
    local ft = vim.bo.filetype

    local function show(item)
      -- Skip a reply for an item that is no longer selected.
      local info = vim.fn.complete_info({ 'completed' })
      if vim.fn.pumvisible() == 0 or vim.tbl_get(info, 'completed', 'word') ~= word then
        return
      end
      local lines = {}
      if item.documentation then
        lines = vim.lsp.util.convert_input_to_markdown_lines(item.documentation)
      end
      -- Put the signature on top, unless the docs already have it.
      local detail = item.detail or ''
      if detail ~= '' and not table.concat(lines, '\n'):find(detail, 1, true) then
        local sig = vim.lsp.util.convert_input_to_markdown_lines({ language = ft, value = detail })
        lines = vim.list_extend(sig, lines)
      end
      if #lines > 0 then completion_buf = show_hover(src, lines) end
    end

    if client:supports_method('completionItem/resolve') then
      client:request('completionItem/resolve', lsp.completion_item, function(err, result)
        show(not err and result or lsp.completion_item)
      end, ev.buf)
    else
      -- Wait until the autocommand ends, windows are locked in it.
      vim.schedule(function() show(lsp.completion_item) end)
    end
  end
})

-- Close the completion docs when the completion menu closes.
vim.api.nvim_create_autocmd('CompleteDone', {
  callback = function()
    if hover_win and vim.api.nvim_win_is_valid(hover_win)
        and vim.api.nvim_win_get_buf(hover_win) == completion_buf then
      vim.api.nvim_win_close(hover_win, false)
    end
  end
})

-- True while the mouse drags the left padding of the hover float.
local resizing = false

-- Resize the hover float by dragging its left padding with the mouse.
-- Other mouse events keep their default action.
local function hover_mouse(key)
  return function()
    local pos = vim.fn.getmousepos()
    if key == '<LeftMouse>' then
      resizing = pos.winid == hover_win and pos.wincol <= 2
    elseif key == '<LeftDrag>' and resizing
        and vim.api.nvim_win_is_valid(hover_win) then
      local src = vim.api.nvim_win_get_config(hover_win).win
      local info = vim.fn.getwininfo(src)[1]
      local w = info.wincol + info.width - pos.screencol
      w = math.max(10, math.min(info.width, w))
      hover_ratio = w / info.width
      vim.api.nvim_win_set_config(hover_win, hover_config(src))
    elseif key == '<LeftRelease>' and resizing then
      resizing = false
      return ''
    end
    return resizing and '' or key
  end
end

for _, key in ipairs({ '<LeftMouse>', '<LeftDrag>', '<LeftRelease>' }) do
  vim.keymap.set({ 'n', 'i' }, key, hover_mouse(key),
    { expr = true, desc = 'Mouse, resizes hover float' })
end

-- Keep the float on the right edge when it or its window is resized.
-- A new float width, from <C-w>< or :vertical resize, sets the ratio.
vim.api.nvim_create_autocmd('WinResized', {
  callback = function()
    if not (hover_win and vim.api.nvim_win_is_valid(hover_win)) then return end
    local src = vim.api.nvim_win_get_config(hover_win).win
    local wins = vim.v.event.windows
    if vim.list_contains(wins, hover_win) then
      local width = vim.fn.getwininfo(src)[1].width
      hover_ratio = math.min(1, vim.api.nvim_win_get_width(hover_win) / width)
    elseif not vim.list_contains(wins, src) then
      return
    end
    vim.api.nvim_win_set_config(hover_win, hover_config(src))
  end
})

-- Enables LSP completion; item docs show in the hover float.
vim.opt.completeopt = { 'menuone', 'noselect' }
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, {
        autotrigger = true,
        -- The float shows the signature; in the menu it would cover the float.
        convert = function() return { menu = '' } end
      })
      vim.keymap.set('i', '<C-Space>', vim.lsp.completion.get, { buffer = ev.buf, desc = 'LSP completion' })
    end
    vim.keymap.set('n', 'K', hover_right, { buffer = ev.buf, desc = 'LSP hover in float' })
  end
})

