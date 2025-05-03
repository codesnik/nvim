-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig

-- ~/.local/share/nvchad/lazy/ui/lua/nvchad/stl/utils.lua
local utils = require "nvchad.stl.utils"
local M = {
  base46 = {
    -- :help nvui.base46.edit_themes
    -- ~/.local/share/nvchad/lazy/base46/lua/base46/themes/tokyodark.lua
    theme = "tokyodark",
    -- :help highlight-groups
    hl_override = {
      Search = { bg = { "light_grey", -2 }, fg = "white" },
      Visual = { bg = { "black", 7 } },
      NvimTreeCursorLine = { bg = { "black", 7 } },
    },
    theme_toggle = {"tokyodark", "tokyonight"},
  },

  ui = {
    tabufline = {
      order = { "treeOffset", "buffers", "tabs" },
    },
    statusline = {
      enabled = true,
      theme = "vscode_colored", -- minimal, vscode_colored, vscode, default
      order = { "mode", "file_path", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "git", "cursor", "cwd" },
      separator_style = "block",
      modules = {
        -- show filename in statusline with path but starting from ~ or .
        file_path = function()
          local file = utils.file()

          local full_path = vim.api.nvim_buf_get_name( vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0) )

          local path = vim.fn.fnamemodify(vim.fn.expand(full_path), ':~:.:h')
          if path == '.' or file[2] == 'Empty' then path = "" else path = "%#St_pwd_text#" .. path .. "/" end

          return "%#St_file# " .. file[1] .. " " .. path .. "%#St_file#" .. file[2] .. "%#St_file_sep#"
        end,
      },
      --[[
      file_info = function()
        local st_modules = require "nvchad_ui.statusline.default"
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
      --]]
    }
  }
}

return M
