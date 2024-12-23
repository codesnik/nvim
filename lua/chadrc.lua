-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
  -- https://nvchad.com/docs/config/theming/
  theme = "catppuccin",
  -- ~/.local/share/nvchad/lazy/base46/lua/base46/themes/catppuccin.lua
  hl_override = {
    Search = { bg = "light_grey", fg = "white" }
  },
  -- theme_toggle = {"catppuccin", "gruvbox_light"},
  tabufline = {
    order = { "treeOffset", "buffers", "tabs" }
  },
  -- ~/.local/share/nvchad/lazy/ui/lua/nvchad/stl/utils.lua
  statusline = {
    theme = "vscode_colored",
    --[[
    overriden_modules = {
      file = function()
        local icon = "󰈚"
        local path = vim.api.nvim_buf_get_name( vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0) )
        local name = (path == "" and "Empty ") or path -- :match "([^/\\]+)[/\\]*$"

        if name ~= "Empty " then
          local devicons_present, devicons = pcall(require, "nvim-web-devicons")

          if devicons_present then
            local ft_icon = devicons.get_icon(name)
            icon = (ft_icon ~= nil and ft_icon) or icon
          end
        end

        return { icon, name }
      end
    },
    --]]
    --[[
    overriden_modules = function()
      local st_modules = require "nvchad_ui.statusline.default"

      return {
        fileInfo = function()
          local fn = vim.fn
          local sep = "%#St_file_sep#"
          local str = st_modules.fileInfo()
          local parts = {}
          for match in (str..sep):gmatch("(.-)"..sep) do
            table.insert(parts, match)
          end
          local new_sep_r = string.gsub(parts[2],' %%','')
          local icon = "  "
          local filename = (fn.expand "%" == "" and "Empty ") or fn.expand "%:t"
          local foldername = (fn.expand("%:p:h") == "" and "Empty") or fn.expand("%:p:h:t")

          local modified_indicator = ""
          if vim.bo.modified then
            modified_indicator = " "
          end

          if filename ~= "Empty " then
            local devicons_present, devicons = pcall(require, "nvim-web-devicons")

            if devicons_present then
              local ft_icon = devicons.get_icon(filename)
              icon = (ft_icon ~= nil and " " .. ft_icon) or ""
            end

            filename = " " .. foldername .. " -> " .. filename .. modified_indicator .. " "
          end

          return "%#St_file_info#" .. icon .. filename .. "%#St_file_sep#" .. new_sep_r .. "WORKS"
        end
      }
    end
    ]]--
  }
}

-- M.nvdash = { load_on_startup = true }
-- M.ui = {
--       tabufline = {
--          lazyload = false
--      }
--}

return M
