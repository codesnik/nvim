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

-- Match case for tag lookups regardless of 'ignorecase'. Default is "followic",
-- which (with NvChad's ignorecase=true) lets <C-]> case-fold CamelCase constants
-- like BulkNodeVariantUpdate onto unrelated snake_case tags from vim-bundler's
-- gem tags. LSP (gd / the C-] tagfunc) still resolves the real definition.
vim.o.tagcase = "match"

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
