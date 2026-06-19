-- run :Lazy or restart
-- :Lazy load plugin-without-namespace

-- plugins installed here(?)
-- ~/.local/share/nvim/lazy/

-- if Lazy update gives for a_plugin ... refspec .invalid
--  rm -rf ~/.local/share/nvim/lazy/a_plugin
--
-- - The plugin only exists as a dependency in your spec
-- - It has an `event`, `cmd`, `ft` or `keys` key
-- - `config.defaults.lazy == true`

---@type LazySpec[]
return {
  ----------------------------
  -- BEGIN of nvchad overrides
  ----------------------------
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
    end
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

  -- File picker
  -- changes: glyphs and alignment, lazy off for auto_open
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    -- event = "VimEnter */",
    lazy = false,
    opts = function()
      local function on_attach(bufnr)
        local api = require("nvim-tree.api")
        api.config.mappings.default_on_attach(bufnr)
        api.events.subscribe(api.events.Event.TreeRendered, function()
          vim.cmd.redrawstatus()
        end)
      end

      return vim.tbl_deep_extend('keep', require("nvchad.configs.nvimtree"),
        {
          on_attach = on_attach,
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
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install({
        "lua", "luadoc", "printf", "vim", "vimdoc",
        "html", "css", "go",
        "markdown", "markdown_inline",
        "ruby", "bash",
      })

      -- Resolve fenced-code info strings to filetypes via vim.filetype.match,
      -- so things like ```path/to/file.rb +23 highlight as ruby.
      -- The bundled directive (master era) crashed on info_strings with no
      -- language node; this version nil-checks before get_node_text.
      local aliases = {
        ex = "elixir", pl = "perl", sh = "bash", uxn = "uxntal",
        ts = "typescript", rb = "ruby", js = "javascript", py = "python",
        zsh = "bash",
      }
      vim.treesitter.query.add_directive("set-lang-from-info-string!",
        function(match, _, bufnr, pred, metadata)
          local node = match[pred[2]]
          if type(node) == "table" then node = node[#node] end
          if not node then return end
          local ok, text = pcall(vim.treesitter.get_node_text, node, bufnr)
          if not ok or not text or text == "" then return end
          text = text:lower()
          local ft = vim.filetype.match({ filename = "a." .. text })
          metadata["injection.language"] = ft or aliases[text] or text
        end, { all = false, force = true })

      -- Highlighting and indent are opt-in per-buffer on the main branch.
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          local ok = pcall(vim.treesitter.start, ev.buf)
          if not ok then return end
          if vim.bo[ev.buf].filetype == "ruby" then
            -- Keep Vim's built-in ruby indent; treesitter indent is buggy here.
            -- Also run the regex syntax alongside treesitter for ruby.
            vim.bo[ev.buf].syntax = "ON"
          else
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        layout_config = {
          horizontal = {
            width = 0.95,
            height = 0.95,
            preview_width = 0.55,
          },
        },
        mappings = {
          i = {
            ["<M-w>"] = require("telescope.actions.layout").toggle_preview,
            ["<M-n>"] = require("telescope.actions").cycle_history_next,
            ["<M-p>"] = require("telescope.actions").cycle_history_prev,
          },
          n = {
            ["<M-w>"] = require("telescope.actions.layout").toggle_preview,
            ["<M-n>"] = require("telescope.actions").cycle_history_next,
            ["<M-p>"] = require("telescope.actions").cycle_history_prev,
          },
        },
      },
      extensions = {
        live_grep_args = {
          auto_quoting = true,
        },
      },
    },
  },

  -- END OF nvchad ovierrides

  ----------------------------
  -- other syntax highlighting
  ----------------------------
  { "slim-template/vim-slim", ft = "slim", },
  { "kchmck/vim-coffee-script", ft = "coffee", },
  { "vim-crystal/vim-crystal", ft = "crystal", },

  -------------
  -- folding
  -------------
  -- { "preservim/vim-markdown", ft = "markdown", },

  --------------
  -- LSP servers
  --------------
  -- :help lsp
  --
  -- install LSP servers with :Mason or :LspInstall
  --
  -- use
  --   :checkhealth vim.lsp
  -- to check current settings

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
        "tailwindcss",
        -- "solargraph",
        "lua_ls",
        "jsonls",
        "yamlls",
        -- "ruby_lsp", -- manage it manually via lsp/ruby_lsp.lua
        "terraformls",
        "gopls",
      },
      automatic_enable = {
        exclude = {
          "solargraph",
          "ruby_lsp", -- managed manually via lsp/ruby_lsp.lua to use asdf shim
          -- "rubocop"
        },
      },
    },
    cmd = { "LspInstall", "LspUninstall" },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
  },

  -- load nvchad LSP defaults for keybindings (TODO: check if it works), and enable lua_ls
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
        float = { border = nil },
      }

      -- enable non-Mason LSP servers
      -- Explicit config takes precedence over lsp/ruby_lsp.lua + nvim-lspconfig's
      -- bundled config. Overrides reuse_client to dedup by root_dir alone — the
      -- bundled version compares cmd_cwd, which is nil on the first start and
      -- causes a second client to spawn (see :LspInfo).
      vim.lsp.config("ruby_lsp", {
        cmd = { vim.fn.expand("~/.asdf/shims/ruby-lsp") },
        init_options = {
          indexing = {
            excludedGems = {
              "parser", "brakeman", "prism", "rdoc", "rouge", "yard", "rbs",
              "rubocop", "rubocop-ast", "rubocop-rails", "rubocop-rspec",
            },
            excludedPatterns = {
              "db/migrate/**/*.rb",
              "db/seeds/**/*.rb",
              "db/seeds.rb",
            },
          },
          addonSettings = {
            ["Ruby LSP Rails"] = { enablePendingMigrationsPrompt = false },
          },
        },
        reuse_client = function(client, config)
          return client.name == config.name and client.config.root_dir == config.root_dir
        end,
      })
      vim.lsp.enable("ruby_lsp")
      -- Eager start at launch (incl. no file open) lives in configs/ruby_lsp.lua,
      -- since this block only runs on "User FilePost".

      -- Neovim 0.11+ uses keymap for K, set buffer-local on LSP attach
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local buf = args.buf
          vim.keymap.set("n", "K", function()
            vim.lsp.buf.hover({ border = "rounded" })
          end, { buffer = buf, desc = "LSP Hover" })

          -- Remove NvChad mappings that have Neovim 0.11+ built-in equivalents
          -- gr -> grr, gi -> gri, <leader>ca -> gra, <leader>ra -> grn
          local function del(mode, lhs)
            pcall(vim.keymap.del, mode, lhs, { buffer = buf })
          end
          del("n", "gr")
          del("n", "gi")
          del({ "n", "v" }, "<leader>ca")
          del("n", "<leader>ra")
          del("n", "<leader>D")
          del("n", "<leader>sh")
        end,
      })
    end,
  },

  { "tpope/vim-repeat", lazy=false },
  { "tpope/vim-abolish", lazy=false },
  { "tpope/vim-fugitive", cmd = { "G", "Git", "Ggrep" } },
  { "tpope/vim-rails", lazy=false }, -- load always
  { "tpope/vim-bundler", lazy=false },
  { "tpope/vim-rhubarb", cmd = "GBrowse" },

  -- Git diff/history review with a real file-list panel
  -- :DiffviewOpen <hash>^!  -> review one commit
  -- :DiffviewFileHistory    -> browse commits, <CR> to drill into one
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
    opts = {},
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview: working tree changes" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: current file history" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview: repo history" },
      { "<leader>gx", "<cmd>DiffviewClose<cr>", desc = "Diffview: close" },
    },
  },
  -- { "chrisbra/matchit", lazy=false },
  { "andymass/vim-matchup", lazy=false,
    init = function()
      -- Disable treesitter integration to avoid nil node error on Neovim 0.12
      -- (nvim-treesitter master branch is archived and incompatible)
      vim.g.matchup_treesitter_enabled = 0
    end,
  },
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
      borders = {
        vert = "│",         -- ┃
        -- Strong headers separate results from different files
        strong_header = "━",
        strong_cross = "┿", -- ╋
        strong_end = "┥",   -- ┫
        -- Soft headers separate results within the same file
        soft_header = "╌",
        soft_cross = "┼",   -- ╂
        soft_end = "┤"      -- ┨
      },
    },
  },

  -- show breadcrumbs
  -- need to check https://github.com/SmiteshP/nvim-navic#lualine
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
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
   -- keys = { "gS", "gJ" } },
  -- TODO: use keys = { .. }
  { "AndrewRadev/splitjoin.vim", lazy = false },

  -- { "github/copilot.vim", cmd = "Copilot" },

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
  --[[
  {
    "carlos-algms/agentic.nvim",
    event = "VeryLazy",
    opts = {
      -- Available by default: "claude-acp" | "gemini-acp" | "codex-acp" | "opencode-acp"
      provider = "claude-acp", -- setting the name here is all you need to get started
    },
    -- these are just suggested keymaps; customize as desired
    keys = {
      {
        "<C-\\>", function() require("agentic").toggle() end,
        mode = { "n", "v", "i" },
        desc = "Toggle Agentic Chat"
      },
      {
        "<C-'>",
        function() require("agentic").add_selection_or_file_to_context() end,
        mode = { "n", "v" },
        desc = "Add file or selection to Agentic to Context"
      },
      {
        "<C-,>",
        function() require("agentic").new_session() end,
        mode = { "n", "v", "i" },
        desc = "New Agentic Session"
      },
    },
  },
  ]]--
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    keys = {
      { "<leader>a",  nil,                              desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>",        mode = "v",                  desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Deny diff" },
    },
  },

  -- Show context in the code if it's above the buffer border
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
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = "nvim-treesitter/nvim-treesitter",
    lazy = false,
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
      })
      local select = require("nvim-treesitter-textobjects.select")
      vim.keymap.set({ "x", "o" }, "ab", function()
        select.select_textobject("@block.outer", "textobjects")
      end, { desc = "Select around block (treesitter)" })
      vim.keymap.set({ "x", "o" }, "ib", function()
        select.select_textobject("@block.inner", "textobjects")
      end, { desc = "Select inner block (treesitter)" })
    end,
  },

  -- Telescope ast_grep
  { "Marskey/telescope-sg" },

  -- Telescope live_grep with shell-style rg args in the prompt
  {
    "nvim-telescope/telescope-live-grep-args.nvim",
    version = "^1.0.0",
    dependencies = "nvim-telescope/telescope.nvim",
    config = function()
      require("telescope").load_extension "live_grep_args"
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
      -- builtin_marks = { ".", "<", ">", "^" },
      cyclic = true,
      force_write_shada = false,
      refresh_interval = 250,
      sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
      --- don't run on nvim tree
      excluded_buftypes = { "terminal", "nofile", "nowrite" },
      excluded_filetypes = { "NvimTree", "TelescopePrompt" },
    }
  },

  -- folding for rspec. does not work?
  -- { "rlue/vim-fold-rspec", lazy = false },

  -- TODO needs mapping
  {
    "enochchau/nvim-pretty-ts-errors",
    build = "npm install",
  },

  -- Symbol outline sidebar with visual nesting (describe/context/it in rspec)
  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = { "AerialToggle", "AerialOpen", "AerialNavToggle" },
    keys = {
      { "<leader>o", "<cmd>AerialToggle!<cr>", desc = "Outline (aerial) toggle" },
    },
    init = function()
      -- Spec files are plain `ruby` filetype, so the per-filetype `backends`
      -- table below can't single them out. Flip them back to LSP-first via the
      -- buffer-local override aerial checks first (b:aerial_backends), so
      -- ruby-lsp-rspec's richer example-group/example outline is used there.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "ruby",
        callback = function(args)
          if vim.api.nvim_buf_get_name(args.buf):match("_spec%.rb$") then
            vim.b[args.buf].aerial_backends = { "lsp", "treesitter", "markdown", "man" }
          end
        end,
      })
    end,
    opts = {
      -- Prefer treesitter on ruby files: it reports method visibility (private/
      -- protected render gray via AerialPrivate), which ruby_lsp does not, and
      -- it catches rspec describe/context/it even before ruby_lsp loads. Spec
      -- files are flipped to LSP-first in `init` above for ruby-lsp-rspec.
      -- Everything else keeps the LSP-first default.
      backends = {
        ruby = { "treesitter", "lsp", "markdown", "man" },
        ["_"] = { "lsp", "treesitter", "markdown", "man" },
      },
      layout = {
        default_direction = "right",
        min_width = 30,
      },
      -- show the full nesting tree, not just the symbols around the cursor
      show_guides = true,
      filter_kind = false, -- show all symbol kinds (rspec blocks are Methods/Modules)
      -- but hide ruby instance variables (@var) that ruby_lsp emits on spec
      -- files; keep class variables (@@var)
      post_parse_symbol = function(_, item, _)
        return not (vim.startswith(item.name, "@") and not vim.startswith(item.name, "@@"))
      end,
    },
  },

  -- Render markdown ONLY inside LSP hover floats (conceals the verbose
  -- file:// URLs in ruby_lsp hover, styles links/code). Deliberately does
  -- NOT render while editing real markdown files.
  {
    "OXY2DEV/markview.nvim",
    event = "VeryLazy", -- load early so its hover/preview hooks are ready
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      preview = {
        -- condition overrides filetypes & ignore_buftypes: true => attach.
        -- Attach ONLY to markdown floats (buftype "nofile"): that's the LSP
        -- hover window. Real markdown files use buftype "" so they stay
        -- unrendered, and other nofile buffers (nvim-tree, qf) are skipped —
        -- attaching to those threw "Parser not found / language could not be
        -- determined" because they have no treesitter parser.
        condition = function(buf)
          return vim.bo[buf].buftype == "nofile"
            and vim.bo[buf].filetype == "markdown"
        end,
      },
    },
  },
}
