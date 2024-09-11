-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "rosepine-dawn",
  theme_toggle = { "rosepine", "rosepine-dawn" },

	hl_override = {
	  Comment = { italic = true },
	  ["@comment"] = { italic = true },
	},
}

M.ui = {
  statusline = {
      -- default/vscode/vscode_colored/minimal
      theme = "default",
      -- default/round/block/arrow 
      separator_style = "block",
    },
    nvdash = {
      load_on_startup = true,
  },
}

M.mason = {
  command = false,
}

return M
