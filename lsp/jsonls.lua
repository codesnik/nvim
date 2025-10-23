-- JSON LSP configuration with schemastore.nvim
return {
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
}
