-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = {
  "html",
  "cssls",
  "pyright",
  "ts_ls",
  "solargraph",
  "terraformls",
  "gopls",
}
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }

-- disable virtual text in lsp
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false
    }
)

-- local nvim_lsp = require 'lspconfig'
-- -- PLUGIN / neovim native lsp / ruby / solargraph
-- require'lspconfig'.solargraph.setup{
--   -- cmd = { os.getenv( "HOME" ) .. "/.asdf/shims/solargraph", 'stdio' },
--   cmd = { nvim_lsp.util.root_pattern("Gemfile", ".git", ".") .. "bin/solargraph", 'stdio' },
--   root_dir = nvim_lsp.util.root_pattern("Gemfile", ".git", "."),
--   settings = {
--     solargraph = {
--       autoformat = false,
--       formatting = false,
--       completion = true,
--       diag(nostic = true,
--       folding = true,
--       references = true,
--       rename = true,
--       symbols = true
--     }
--   }
-- }
