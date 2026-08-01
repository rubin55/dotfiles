-- Enable notifications.
require('fidget').setup({
  notification = {
    override_vim_notify = true,
    window = {
      avoid = { 'NvimTree' },
      y_padding = 1
    }
  }
})
