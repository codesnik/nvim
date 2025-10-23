-- run :Lazy or restart
-- :Lazy load plugin-without-namespace
return {
  -- BEGIN of nvchad overrides
  -- nvchad defaults are there
  -- ~/.local/share/nvchad/lazy/NvChad/lua/nvchad/plugins/init.lua

  -- have to disable by explicit unloading
  -- { "windwp/nvim-autopairs", enabled = false },

  -- changes: add delay
  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    cmd = "WhichKey",
    opts = function()
      dofile(vim.g.base46_cache .. "whichkey")
      return {
        delay = 500
      }
    end,
  },

  -- Indent outlines
  -- changes: update indent chars
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

  -- file managing , picker etc
  -- changes: glyphs and alignment, lazy off for auto_open
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    -- event = "VimEnter */",
    lazy = false,
    opts = function()
      return vim.tbl_deep_extend('keep', require("nvchad.configs.nvimtree"),
        {
          renderer = {
            -- hidden_display = "all",
            icons = {
              git_placement = "right_align",
              glyphs = {
                git = {
                  untracked = "*"
                }
              }
            }
          },
          hijack_directories = {
            enable = true,
            auto_open = true,
          }
        }
      )
    end,
  },

  -- syntax highlighting plugins (TreeSitter)
  -- run :TSInstall
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "lua",
        "luadoc",
        "printf",
        "vim",
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
        use_languagetree = true,
        additional_vim_regex_highlighting = { "ruby" },
      },
      indent = { enabled = true, disable = { "ruby" } },
      -- TODO: this is for https://github.com/RRethy/nvim-treesitter-endwise 
      -- endwise = {
      --   enable = true,
      -- }
    },
  },

  -- END OF nvchad ovierrides

  -- other syntax highlighting
  { "slim-template/vim-slim", ft = "slim", },
  { "kchmck/vim-coffee-script", ft = "coffee", },
  { "vim-crystal/vim-crystal", ft = "crystal", },

  -- folding
  -- { "preservim/vim-markdown", ft = "markdown", },

  -- LSP servers
  -- :help lsp
  --
  -- install LSP servers with :Mason or :LspInstall
  --
  -- use
  --   :checkhealth vim.lsp
  -- to check current settings
  --
  -- load nvchad LSP defaults for keybindings (TODO: check if it works), and enable lua_ls

  -- FIXME: should be lazy?
  {
    "mason-org/mason-lspconfig.nvim",
    event = "User FilePost",
    -- lazy = false,
    opts = {
      ensure_installed = {
        "html",
        "cssls",
        "pyright",
        "ts_ls",
        "solargraph",
        "lua_ls",
        "jsonls",
        "yamlls",
        "ruby_lsp",
        "terraformls",
        "gopls",
        "postgres_lsp",
      },
    },
    cmd = { "LspInstall", "LspUninstall" },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = "User FilePost",
    config = function()
      require("nvchad.configs.lspconfig").defaults()

      -- overrides for ~/.local/share/nvim/lazy/ui/lua/nvchad/lsp/init.lua
      local x = vim.diagnostic.severity
      vim.diagnostic.config {
        virtual_text = false, -- { prefix = "" },
        virtual_lines = false,
        underline = false,
        signs = { text = { [x.ERROR] = "󰅙", [x.WARN] = "", [x.INFO] = "󰋼", [x.HINT] = "󰌵" } },
        float = { border = "rounded" },
      }
    end,
  },

  { "tpope/vim-repeat", lazy=false },
  { "tpope/vim-fugitive", cmd = { "Git", "Ggrep" } },
  { "tpope/vim-rails", lazy=false }, -- load always
  { "tpope/vim-bundler", lazy=false },
  { "tpope/vim-rhubarb", cmd = "GBrowse" },
  -- { "chrisbra/matchit", lazy=false },
  { "andymass/vim-matchup", lazy=false },
  { "knsh14/vim-github-link", cmd = {"GetCommitLink", "GetCurrentBranchLink", "GetCurrentCommitLink"} },
  -- vim file:line
  { "wsdjeg/vim-fetch", lazy=false },
  -- ae, ie
  { "kana/vim-textobj-entire", lazy=false, dependencies={ "kana/vim-textobj-user" } },
  -- aa, ii
  { "wellle/targets.vim", lazy=false, dependencies={ "kana/vim-textobj-user" } },
  -- grr - VP works the same
  -- { "vim-scripts/ReplaceWithRegister", lazy=false },

  {
    'stevearc/quicker.nvim',
    event = "FileType qf",
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {
      keys = {
        {
          ">",
          function()
            require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
          end,
          desc = "Expand quickfix context",
        },
        {
          "<",
          function()
            require("quicker").collapse()
          end,
          desc = "Collapse quickfix context",
        },
      },
    },
  },

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

  -- Show context in the code if it's above the buffer borde
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    cmd = {"TSContext"},
    opts = {
      enabled = true
    },
    config = function(_, opts)
      vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = true, sp = "#333333" })
      vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", { underline = true, sp = "#333333" })
      require("treesitter-context").setup(opts)
    end,
  },

  -- select ruby blocks
  -- TODO: try `event = "VeryLazy",
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
    lazy = false,
    config = function(_opts)
      require("nvim-treesitter.configs").setup({
        textobjects = {
          select = {
            enable = true,
            keymaps = {
              -- Block selection (customize for your language)
              ["ab"] = "@block.outer", -- `vab` to select around block
              ["ib"] = "@block.inner", -- `vib` to select inner block
            }
          }
        }
      })
    end,
  },


  -- TODO try that for inner indentation
  -- https://github.com/chrisgrieser/nvim-various-textobjs
  { "chrisgrieser/nvim-various-textobjs" },

  { "mrjones2014/dash.nvim", cmd = "Dash", build = "make install" },

  -- schemas for json and yaml
  { "b0o/schemastore.nvim" },

  -- marks visualization in sign column
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {
      default_mappings = true,
      signs = true,
      builtin_marks = { ".", "<", ">", "^" },
      cyclic = true,
      force_write_shada = false,
      refresh_interval = 250,
      sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
    }
  }

  -- Disable mouse and repeating keys
  -- {
  --  "m4xshen/hardtime.nvim",
  --  lazy = false,
  --  dependencies = { "MunifTanjim/nui.nvim" },
  --  opts = {},
  -- },

  -- folding for rspec. does not work?
  -- { "rlue/vim-fold-rspec", lazy = false },
}
