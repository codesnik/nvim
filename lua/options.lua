-- ~/.local/share/nvchad/lazy/NvChad/lua/nvchad/options.lua
require "nvchad.options"

vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.o.list=true
vim.o.wrapscan=false
-- vim.o.expandtab=false

vim.g.editorconfig = false
-- vim.o.signcolumn = "auto"

vim.o.confirm = true

vim.diagnostic.config {
  virtual_text = false,
  virtual_lines = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
}
