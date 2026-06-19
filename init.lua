-- ~/.config/nvim/lua/plugins/init.lua
-- ~/.config/nvim/lua/options.lua
-- ~/.config/nvim/lua/mappings.lua
-- ~/.config/nvim/lua/chadrc.lua -- themes and colors

-- ~/.local/share/nvchad/lazy/NvChad/ -- nvchad stuff

vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "
vim.g.maplocalleader = " "

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

-- Eagerly start + index ruby_lsp at launch in a Ruby project, even with no file
-- open. Must live here (not in the lazy lspconfig block) since that block only
-- runs on "User FilePost", which never fires without a file.
require("configs.ruby_lsp").setup()

-- open splits vertical by default for man and help
-- FIXME: does not work
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

-- :terminal palette — match iTerm2 default profile ANSI colors
local terminal_palette = {
  [0]  = "#000000", [1]  = "#bb0000", [2]  = "#00bb00", [3]  = "#bbbb00",
  [4]  = "#2e51ee", [5]  = "#bb00bb", [6]  = "#00bbbb", [7]  = "#bbbbbb",
  [8]  = "#555555", [9]  = "#ff5555", [10] = "#55ff55", [11] = "#ffff55",
  [12] = "#5555ff", [13] = "#ff55ff", [14] = "#55ffff", [15] = "#ffffff",
}
local function apply_terminal_palette()
  for i, hex in pairs(terminal_palette) do
    vim.g["terminal_color_" .. i] = hex
  end
end
-- nvchad.term re-runs base46's term cache on first require; preload it so our
-- palette wins on the first <M-h> split too
pcall(require, "nvchad.term")
apply_terminal_palette()
vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_terminal_palette })
