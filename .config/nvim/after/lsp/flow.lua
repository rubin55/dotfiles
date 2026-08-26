-- Start flow only in files with a // @flow pragma before any code.
return {
  root_dir = function(bufnr, on_dir)
    for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, 100, false)) do
      if line:match('^%s*// @flow') then
        on_dir(vim.fs.root(bufnr, { '.flowconfig', '.git' }) or vim.fn.getcwd())
        return
      end
      if line:match('%S') and not line:match('^%s*//') then
        return -- code started without a pragma
      end
    end
  end,
}
