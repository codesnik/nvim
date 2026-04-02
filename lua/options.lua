-- ~/.local/share/nvchad/lazy/NvChad/lua/nvchad/options.lua
require "nvchad.options"

vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.o.list=true
vim.o.wrapscan=false
-- vim.o.expandtab=false

vim.g.editorconfig = false
vim.o.signcolumn = "yes"

vim.o.confirm = true
vim.o.inccommand = 'split'
