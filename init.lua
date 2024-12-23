-- ~/.config/nvchad/lua/plugins/init.lua
-- ~/.config/nvchad/lua/options.lua
-- ~/.config/nvchad/lua/mappings.lua
-- ~/.config/nvchad/lua/chadrc.lua
-- ~/.config/nvchad/lua/configs/lspconfig.lua
vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

require("nvim-autopairs").disable()

require("nvim-tree").setup({
  update_focused_file = { enable = true },
  renderer = {
    icons = {
      git_placement = "after", -- before/after
      glyphs = {
        git = {
          untracked = "*"
        }
      }
    }
  },
})

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

-- local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
-- vim.keymap.set("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
-- vim.keymap.set("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
