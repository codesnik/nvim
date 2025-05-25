-- run :Lazy or restart
return {
  -- nvchad defaults are there
  -- ~/.local/share/nvchad/lazy/NvChad/lua/nvchad/plugins/init.lua

  -- { "windwp/nvim-autopairs", enabled = false },

  -- Indent outlines. Just updating indent char
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "User FilePost",
    opts = {
      indent = { char = "▏", highlight = "IblChar" },
      scope = { char = "▏", highlight = "IblScopeChar" },
    },
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "blankline")

      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
      require("ibl").setup(opts)

      dofile(vim.g.base46_cache .. "blankline")
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = function()
      return vim.tbl_deep_extend('keep', require("nvchad.configs.nvimtree"),
        {
          renderer = {
            hidden_display = "all",
            icons = {
              git_placement = "right_align",
              glyphs = {
                git = {
                  untracked = "*"
                }
              }
            }
          },
        }
      )
    end,
  },

  -- end of ovierrides

  -- LSP servers
  -- run :MasonInstallAll
  -- add ~/.config/nvim/lua/configs/lspconfig.lua
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "html-lsp",
        "css-lsp",
        "prettier",
        "solargraph",
        "postgrestools",
        -- "gopls",
      },
    },
  },

  -- default configuration for LSP server plugins
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "ts-server"
      },
    },
  },

  -- syntax highlighting plugins (TreeSitter)
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
        "markdown",
        "markdown_inline",
        "ruby",
        "bash",
      },
      -- fixing ruby indentation. doesn't help. 
      -- what helps but should be unnecessary is
      -- :TSDisable indent
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "ruby" },
      },
      indent = { enabled = true, disable = { "ruby" } },
      -- TODO: this is for https://github.com/RRethy/nvim-treesitter-endwise 
      -- endwise = {
      --   enable = true,
      -- }
    },
  },

  -- other syntax highlighting
  { "slim-template/vim-slim", ft = "slim", },
  { "kchmck/vim-coffee-script", ft = "coffee", },
  { "vim-crystal/vim-crystal", ft = "crystal", },

  -- folding
  -- { "preservim/vim-markdown", ft = "markdown", },

  { "tpope/vim-repeat", lazy=false },
  { "tpope/vim-fugitive", cmd = { "Git", "Ggrep" } },
  { "tpope/vim-rails", lazy=false }, -- load always
  { "tpope/vim-bundler", lazy=false },
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

  -- added/uncommented by me

  { "kylechui/nvim-surround", event = "VeryLazy", opts = {} },
  { "AndrewRadev/splitjoin.vim", lazy = false }, -- keys = { "gS", "gJ" } },

  { "github/copilot.vim", cmd = "Copilot" },

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

  -- Show context in the code if it's above the buffer borde
  {
    "nvim-treesitter/nvim-treesitter-context",
    cmd = {"TSContextEnable", "TSContextDisable", "TSContextToggle"},
  },

  -- Disable mouse and repeating keys
  -- {
  --  "m4xshen/hardtime.nvim",
  --  lazy = false,
  --  dependencies = { "MunifTanjim/nui.nvim" },
  --  opts = {},
  -- },
}
