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

-- Commonly used, so lower-case.
vim.keymap.set('n', '<Leader>fb', fzf.buffers, { desc = 'Show buffers' })
vim.keymap.set('n', '<Leader>ff', fzf.files, { desc = 'Show files' })
vim.keymap.set('n', '<Leader>fg', fzf.grep_project, { desc = 'Show grep' })

-- Less-commonly used, upper-case.
vim.keymap.set('n', '<Leader>fa', fzf.builtin, { desc = 'Show all available pickers' })
vim.keymap.set('n', '<Leader>fc', fzf.git_commits, { desc = 'Show git commits' })
vim.keymap.set('n', '<Leader>fd', fzf.diagnostics_workspace, { desc = 'Show workspace diagnostics' })
vim.keymap.set('n', '<Leader>fh', fzf.help_tags, { desc = 'Show help' })
vim.keymap.set('n', '<Leader>fk', fzf.keymaps, { desc = 'Show keymaps' })
vim.keymap.set('n', '<Leader>fr', fzf.lsp_references, { desc = 'Show references' })
vim.keymap.set('n', '<Leader>fs', fzf.lsp_live_workspace_symbols, { desc = 'Show symbols' })
vim.keymap.set('n', '<Leader>ft', fzf.treesitter, { desc = 'Show treesitter' })
