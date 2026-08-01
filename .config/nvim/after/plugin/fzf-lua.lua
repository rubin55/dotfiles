-- Fzf configuration.
local fzf = require('fzf-lua')
local actions = require('fzf-lua.actions')

-- Detect the remote's default branch via refs/remotes/origin/HEAD.
local function git_default_branch()
  local head = vim.fn.system({
    'git', 'symbolic-ref', 'refs/remotes/origin/HEAD', '--short'
  })
  if vim.v.shell_error == 0 and head:find('^origin/') then
    return head:gsub('^origin/', ''):gsub('%s+$', '')
  end
  for _, name in ipairs({ 'main', 'master' }) do
    if vim.fn.system({ 'git', 'rev-parse', '--verify', name }):match('%x') then
      return name
    end
  end
  return '@{u}'
end

fzf.setup({
  'borderless',
  ui_select = {},
  fzf_opts = {
    ['--no-bold'] = true,
    ['--exact'] = true,
    ['--wrap'] = true,
  },
  grep = {
    rg_opts = '--column --line-number --no-heading --color=always --smart-case --sort=path -e',
    fzf_opts = {
      ['--no-sort'] = true,
    },
  },
  git = {
    commits = {
      actions = {
        ['ctrl-x'] = {
          fn = function(_, o)
            local base = o.cmd:gsub('%s+%S+%.%.HEAD$', '')
            fzf.git_commits(vim.tbl_extend('force', o, {
              cmd = o.cmd:find('%.%.HEAD$') and base
                or base .. ' ' .. git_default_branch() .. '..HEAD'
            }))
          end,
          header = 'toggle branch only',
        },
      },
    },
  },
  actions = {
    files = {
      true,
      ['enter']  = actions.file_edit_or_qf,
      ['ctrl-s'] = actions.file_split,
      ['ctrl-v'] = actions.file_vsplit,
      ['ctrl-t'] = actions.file_tabedit,
      ['alt-q']  = actions.file_sel_to_qf,
      ['alt-Q']  = actions.file_sel_to_ll,
      ['alt-i']  = actions.toggle_ignore,
      ['alt-h']  = actions.toggle_hidden,
      ['alt-f']  = actions.toggle_follow,
    },
  },
  winopts = {
    split = 'belowright new'
  }
})

vim.keymap.set('n', '<Leader>a', fzf.builtin, { desc = 'All pickers' })
vim.keymap.set('n', '<Leader>b', fzf.buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<Leader>c', fzf.git_commits, { desc = 'Commits' })
vim.keymap.set('n', '<Leader>d', fzf.diagnostics_workspace, { desc = 'Diagnostics' })
vim.keymap.set('n', '<Leader>f', fzf.files, { desc = 'Files' })
vim.keymap.set('n', '<Leader>g', fzf.grep_project, { desc = 'Grep' })
vim.keymap.set('n', '<Leader>h', fzf.help_tags, { desc = 'Help' })
vim.keymap.set('n', '<Leader>k', fzf.keymaps, { desc = 'Keymaps' })
vim.keymap.set('n', '<Leader>r', fzf.lsp_references, { desc = 'References' })
vim.keymap.set('n', '<Leader>s', fzf.lsp_live_workspace_symbols, { desc = 'Symbols' })
vim.keymap.set('n', '<Leader>t', fzf.treesitter, { desc = 'Treesitter' })
