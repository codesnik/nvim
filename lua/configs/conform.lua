local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    sql = { "sqlfluff" },
    markdown = { "injected" },
    -- css = { "prettier" },
    -- html = { "prettier" },
  },

  formatters = {
    sqlfluff = {
      args = { "format", "--dialect=mysql", "--disable-progress-bar", "--nocolor", "-" },
    },
  },

  -- format_on_save = {
  --   -- These options will be passed to conform.format()
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}

return options
