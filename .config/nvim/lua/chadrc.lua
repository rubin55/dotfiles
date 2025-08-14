-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "poimandres",
  theme_toggle = { "poimandres", "github_light" },

	hl_override = {
	  Comment = { italic = true },
	  ["@comment"] = { italic = true },
	},
}

M.ui = {
  tabufline = {
    enabled = false,
  },

  statusline = {
    -- default/vscode/vscode_colored/minimal
    theme = "default",
    -- default/round/block/arrow 
    separator_style = "block",

    -- statusline with line and col position
    modules = {
      cursor = function()
        local fn = vim.fn
        local sep_l = "█"
        local line = fn.line "."
        local col = fn.virtcol "."

        local chad = string.format(" %d:%d", line, col) .. " │ "

        -- default cursor_position module
        local left_sep = "%#St_pos_sep#" .. sep_l .. "%#St_pos_icon#" .. " "

        local current_line = fn.line "."
        local total_line = fn.line "$"
        local text = math.modf((current_line / total_line) * 100) .. tostring "%%"
        text = string.format("%4s", text)

        text = (current_line == 1 and "Top") or text
        text = (current_line == total_line and "Bot") or text

        return left_sep .. "%#St_pos_text#" .. chad .. text .. " "
      end,
      mode = function()
        local utils = require 'nvchad.stl.utils'
        local sep_r = "█"

        if not utils.is_activewin() then
          return ""
        end

        local modes = utils.modes
        local mode = vim.api.nvim_get_mode().mode

        -- removed the icon here
        local current_mode = "%#St_" .. modes[mode][2] .. "Mode# " .. modes[mode][1]
        local mode_sep1 = "%#St_" .. modes[mode][2] .. "ModeSep#" .. sep_r

        return current_mode .. mode_sep1 .. "%#ST_EmptySpace#" .. sep_r
end,
    }
  }
}


M.nvdash = {
  load_on_startup = true,

  header = {
    "           ▄ ▄                   ",
    "       ▄   ▄▄▄     ▄ ▄▄▄ ▄ ▄     ",
    "       █ ▄ █▄█ ▄▄▄ █ █▄█ █ █     ",
    "    ▄▄ █▄█▄▄▄█ █▄█▄█▄▄█▄▄█ █     ",
    "  ▄ █▄▄█ ▄ ▄▄ ▄█ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄  ",
    "  █▄▄▄▄ ▄▄▄ █ ▄ ▄▄▄ ▄ ▄▄▄ ▄ ▄ █ ▄",
    "▄ █ █▄█ █▄█ █ █ █▄█ █ █▄█ ▄▄▄ █ █",
    "█▄█ ▄ █▄▄█▄▄█ █ ▄▄█ █ ▄ █ █▄█▄█ █",
    "    █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█ █▄█▄▄▄█    ",
    "                                 ",
    "       Powered By  eovim       ",
    "                                 ",
  },

   buttons = {
     { txt = "  Find File", keys = "ff", cmd = "Telescope find_files", no_gap = true },
     { txt = "  Recent Files", keys = "fo", cmd = "Telescope oldfiles", no_gap = true },
     { txt = "󰈭  Find Word", keys = "fw", cmd = "Telescope live_grep", no_gap = true},
     { txt = "  Bookmarks", keys = "ma", cmd = "Telescope marks", no_gap = true},
     { txt = "󱥚  Themes", keys = "th", cmd = ":lua require('nvchad.themes').open()", no_gap = true },
     { txt = "  Mappings", keys = "ch", cmd = "NvCheatsheet", no_gap = true },

     { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },

     {
       txt = function()
         local stats = require("lazy").stats()
         local ms = math.floor(stats.startuptime) .. " ms"
         return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
       end,
       hl = "NvDashFooter",
       no_gap = true,
     },

     { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
   },
}

M.mason = {
  command = false,
}

return M
