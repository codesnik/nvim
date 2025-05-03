-- originals are at ~/.local/share/nvchad/lazy/NvChad/lua/nvchad/plugins/init.lua:77
-- and configs are at ~/.local/share/nvchad/lazy/NvChad/lua/nvchad/configs/cmp.lua
--
-- new configs are at ~/.config/nvim/lua/configs/cmp.lua

  -- load luasnips + cmp related in insert mode only
  -- {
  --   "hrsh7th/nvim-cmp",
  --   event = "InsertEnter",
  --   dependencies = {
  --     {
  --       -- snippet plugin
  --       "L3MON4D3/LuaSnip",
  --       dependencies = "rafamadriz/friendly-snippets",
  --       opts = { history = true, updateevents = "TextChanged,TextChangedI" },
  --       config = function(_, opts)
  --         require("luasnip").config.set_config(opts)
  --         require "nvchad.configs.luasnip"
  --       end,
  --     },
  --
  --     -- autopairing of (){}[] etc
  --     {
  --       "windwp/nvim-autopairs",
  --       opts = {
  --         fast_wrap = {},
  --         disable_filetype = { "TelescopePrompt", "vim" },
  --       },
  --       config = function(_, opts)
  --         require("nvim-autopairs").setup(opts)
  --
  --         -- setup cmp for autopairs
  --         local cmp_autopairs = require "nvim-autopairs.completion.cmp"
  --         require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
  --       end,
  --     },
  --
  --     -- cmp sources plugins
  --     {
  --       "saadparwaiz1/cmp_luasnip",
  --       "hrsh7th/cmp-nvim-lua",
  --       "hrsh7th/cmp-nvim-lsp",
  --       "hrsh7th/cmp-buffer",
  --       "hrsh7th/cmp-path",
  --     },
  --   },
  --   opts = function()
  --     return require "nvchad.configs.cmp"
  --   end,
  --   config = function(_, opts)
  --     require("cmp").setup(opts)
  --   end,
  -- },

-- return {{
--   'hrsh7th/nvim-cmp',
--   opts = function(_, opts)
--     local cmp = require('cmp')
--
--     opts.sources = cmp.config.sources({
--       { name = 'nvim_lsp' },
--       { name = 'buffer' },
--       { name = 'path' },
--     })
--   end,
-- }}

return {
  'hrsh7th/nvim-cmp',
  opts = function(_, opts)
    return require('configs.cmp');
  end,
}
