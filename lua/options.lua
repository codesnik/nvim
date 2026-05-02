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

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.opt_local.foldlevel = 99
  end,
})

vim.opt.foldtext = ""
-- vim.opt.foldtext = [[substitute(getline(v:foldstart), '^\s\+', '', '') . ' (' . (v:foldend - v:foldstart + 1) . ') ']]
-- vim.opt.fillchars:append({ fold = "-" })
