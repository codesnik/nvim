-- ~/.config/nvim/lua/plugins/init.lua
-- ~/.config/nvim/lua/options.lua
-- ~/.config/nvim/lua/mappings.lua
-- ~/.config/nvim/lua/chadrc.lua -- themes and colors

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

-- have to do this because "windwp/nvim-autopairs" is a 
-- a dependency of "hrsh7th/nvim-cmp" in nvchad config
require("nvim-autopairs").disable()

require "options"

-- ~/.local/share/nvchad/lazy/NvChad/lua/nvchad/autocmds.lua
require "nvchad.autocmds"

-- try to run rails.vim setup for .notes/*.md for gf to work
-- FIXME: rails.vim is not loaded yet
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.md",
  callback = function()
    vim.cmd("call rails#ruby_setup()")
  end,
})

-- load theme
-- dofile(vim.g.base46_cache .. "syntax")
-- dofile(vim.g.base46_cache .. "defaults")
-- dofile(vim.g.base46_cache .. "statusline")

for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
  dofile(vim.g.base46_cache .. v)
end

vim.schedule(function()
  require "mappings"
end)

-- open splits vertical by default for man and help
vim.api.nvim_create_autocmd("WinNew", {
  -- pattern = "*",
  pattern = { "help", "man" },
  command = "wincmd L",
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
