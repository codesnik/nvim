-- Use asdf shim so ruby-lsp runs under the project's Ruby version
-- instead of Mason's wrapper which hardcodes the global Ruby.
-- Mirrors lspconfig's default cmd structure (function form to set cwd).
return {
  cmd = function(dispatchers, config)
    return vim.lsp.rpc.start(
      { vim.fn.expand("~/.asdf/shims/ruby-lsp") },
      dispatchers,
      config and config.root_dir and { cwd = config.cmd_cwd or config.root_dir }
    )
  end,
}
