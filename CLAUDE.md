# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration forked from NvChad/starter. The configuration is structured to override and extend NvChad's defaults while maintaining compatibility with the NvChad plugin ecosystem.

## Architecture

### Bootstrap and Loading Order

The configuration follows a specific loading sequence defined in `init.lua`:

1. **Plugin Manager Bootstrap**: Lazy.nvim is auto-installed and configured
2. **Plugin Loading**: NvChad base plugins loaded first, then custom plugins from `lua/plugins/init.lua`
3. **Special Workaround**: `nvim-autopairs` is explicitly disabled after loading (it's a dependency of nvim-cmp in NvChad config)
4. **Options Loading**: Custom options from `lua/options.lua`
5. **Autocmds**: NvChad autocmds loaded
6. **Theme Loading**: Base46 theme cache files loaded dynamically
7. **Mappings**: Custom keymaps loaded last via `vim.schedule()`

### Configuration File Structure

- `init.lua` - Entry point and bootstrap logic
- `lua/plugins/init.lua` - Plugin specifications with NvChad overrides
- `lua/options.lua` - Vim options and diagnostic configuration
- `lua/mappings.lua` - Custom keybindings
- `lua/chadrc.lua` - Theme and UI customization (statusline, colors)
- `lua/configs/` - Plugin-specific configurations
  - `lua/configs/lazy.lua` - Lazy.nvim settings
  - `lua/configs/cmp.lua` - Completion configuration (manual trigger, custom Tab behavior)

### NvChad Override Pattern

Plugins in `lua/plugins/init.lua` follow a specific pattern:
- Plugins listed at the top override NvChad defaults (e.g., `which-key.nvim`, `indent-blankline.nvim`, `nvim-tree.lua`, `nvim-treesitter`)
- Each override uses `opts` function that extends NvChad config via `vim.tbl_deep_extend` or returns modified options
- Custom plugins added below the "END OF nvchad overrides" comment

### Key Customizations

**Ruby Development Focus:**
- TreeSitter indent disabled for Ruby (known issue with Ruby indentation)
- vim-rails integration attempted in autocmd (Note: FIXME indicates rails.vim loads too late)
- LSP servers include solargraph and ruby_lsp
- Custom telescope mapping for Ruby-only grep (`<leader>fr`)

**Completion Behavior:**
- Autocomplete is disabled by default (`autocomplete = false`)
- Tab/S-Tab trigger completion manually when typing
- Completion requires `<CR>` to confirm (no auto-select)

**File Navigation:**
- `.notes/` directory integration for git branch-based notes (`<leader>Q` opens branch-specific note)
- Telescope configured for quick file/buffer access

**Statusline:**
- Custom `file_path` module shows file path starting from `~` or `.` with directory context

## Development Commands

### Plugin Management

```bash
# Open lazy.nvim UI
nvim
:Lazy

# Load a specific plugin (if lazy-loaded)
:Lazy load <plugin-name-without-namespace>

# Install TreeSitter parsers
:TSInstall <language>
:TSInstall ruby lua go html css markdown

# Disable TreeSitter features
:TSDisable indent  # Common for Ruby files
```

### LSP Management

```bash
# Install LSP servers
:Mason           # Open Mason UI
:LspInstall      # Install server for current filetype
:LspUninstall    # Uninstall LSP server

# Check LSP health
:checkhealth vim.lsp

# LSP servers configured in lua/plugins/init.lua (mason ensure_installed):
# html, cssls, pyright, ts_ls, tailwindcss, solargraph, lua_ls,
# jsonls, yamlls, terraformls, gopls
#
# ruby_lsp is managed manually via lsp/ruby_lsp.lua and enabled with
# vim.lsp.enable("ruby_lsp") in the nvim-lspconfig config block.
```

### Theme and UI

```bash
# Theme configured in lua/chadrc.lua
# Current theme: "tokyodark"
# theme_toggle cycles between: vscode_dark ↔ tokyonight

# Reload theme after changes
:lua for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do dofile(vim.g.base46_cache .. v) end

# View highlight groups
:help highlight-groups
```

## Important File Locations

**NvChad Base Files** (referenced in comments, read-only):
- `~/.local/share/nvchad/lazy/NvChad/lua/nvchad/plugins/init.lua` - Default plugin specs
- `~/.local/share/nvchad/lazy/NvChad/lua/nvchad/options.lua` - Default options
- `~/.local/share/nvchad/lazy/NvChad/lua/nvchad/mappings.lua` - Default keymaps
- `~/.local/share/nvchad/lazy/NvChad/lua/nvchad/autocmds.lua` - Default autocmds
- `~/.local/share/nvchad/lazy/ui/lua/nvchad/stl/utils.lua` - Statusline utilities

**Plugin Data**:
- `~/.local/share/nvim/lazy/` - Installed plugins
- `vim.fn.stdpath("data")` returns `~/.local/share/nvim/`

## Notes and Gotchas

- **Ruby Indentation**: TreeSitter indent is explicitly disabled for Ruby files due to formatting issues. Uses Vim's built-in Ruby indentation instead.
- **Autopairs Disabled**: nvim-autopairs is forcibly disabled in init.lua despite being a dependency of nvim-cmp in NvChad.
- **Lazy Loading**: nvim-tree is set to `lazy = false` to enable `auto_open` for directory hijacking.
- **Rails.vim**: There's a FIXME for rails.vim not being loaded early enough for markdown file autocmd to work properly.
- **EditorConfig Disabled**: `vim.g.editorconfig = false` in options.lua
- **Diagnostic Configuration**: Virtual text, virtual lines, and underline all disabled — only signs are shown (toggleable at runtime via `<leader>dk`/`<leader>du`/`<leader>dt`)
- **File References**: Comments throughout reference the upstream NvChad file paths to help locate default configurations being overridden
