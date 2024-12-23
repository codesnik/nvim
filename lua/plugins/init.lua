-- run :Lazy or restart
return {

  -- lsp servers
  -- run :MasonInstallAll
  -- add ~/.config/nvchad/lua/configs/lspconfig.lua
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "html-lsp",
        "css-lsp",
        "prettier",
        "gopls"
      },
    },
  },

  -- default configuration for lsp server plugins
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "ts-server"
      },
    },
  },

  -- syntax highlighting plugins
  -- run :TSInstall
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "go",
      },
    },
  },

  -- other syntax highlighting
  { "slim-template/vim-slim", ft = "slim", },
  { "kchmck/vim-coffee-script", ft = "coffee", },
  { "vim-crystal/vim-crystal", ft = "crystal", },

  { "tpope/vim-unimpaired", keys={"[", "]"} },
  { "tpope/vim-repeat", lazy=false },
  { "tpope/vim-fugitive", cmd = "Git" },
  { "tpope/vim-rails", cmd = {"Rails", "A", "R"} },
  { "tpope/vim-rhubarb", cmd = "GBrowse" },
  { "knsh14/vim-github-link", cmd = {"GetCommitLink", "GetCurrentBranchLink", "GetCurrentCommitLink"} },
  -- vim file:line
  { "wsdjeg/vim-fetch", lazy=false },
  -- ae, ie
  { "kana/vim-textobj-entire", lazy=false, dependencies={ "kana/vim-textobj-user" } },

  -- need to check https://github.com/SmiteshP/nvim-navic#lualine
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      -- configurations go here
    },
    cmd = "Barbecue"
  },

  --[[
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },
  ]]

  -- These are some examples, uncomment them if you want to see them work!
  -- {
  --   "neovim/nvim-lspconfig",
  --   config = function()
  --     require("nvchad.configs.lspconfig").defaults()
  --     require "configs.lspconfig"
  --   end,
  -- },
  --
  -- {
  -- 	"williamboman/mason.nvim",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"lua-language-server", "stylua",
  -- 			"html-lsp", "css-lsp" , "prettier"
  -- 		},
  -- 	},
  -- },
  --
  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
  -- added/uncommented by me
  { "kylechui/nvim-surround", event = "VeryLazy", opts = {} },
  { "AndrewRadev/splitjoin.vim", lazy = false }, -- keys = { "gS", "gJ" } },

  { "github/copilot.vim",
    cmd = "Copilot",
  },

  -- {"windwp/nvim-autopairs", enable=false},

  --[[
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({})
    end,
  },
  --]]

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  -- does not work somehow
  {
    "nvim-treesitter/nvim-treesitter-context",
    cmd = {"TSContextEnable", "TSContextDisable", "TSContextToggle"},
  },
}
