-- ~/.local/share/nvchad/lazy/NvChad/lua/nvchad/mappings.lua
require "nvchad.mappings"

vim.keymap.del("n", "<C-c>")
vim.keymap.set("n", "<leader>cc", "<cmd>%y+<CR>", { desc = "general copy whole file" })

-- vim.keymap.set("n", ";", ":", { desc = "CMD enter command mode" })

-- vim.keymap.set("n", "<leader>.", ":e ~/.config/nvim/init.lua<cr>", { desc = "Edit init.lua" })

-- telescope
local telescope = require 'telescope.builtin'
vim.keymap.set("n", "<leader><leader>", telescope.find_files, { desc = "telescope find files" })

vim.keymap.set("n", "<leader>fn", function()
  telescope.find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = 'telescope neovim files' })

vim.keymap.set({"n", "v"}, "<leader>fW", function()
  telescope.grep_string() -- { word_match = true }
end, { desc = 'telescope grep string' })

vim.keymap.set({"n", "v"}, "<leader>fr", function()
  telescope.live_grep{type_filter = "ruby"} -- { word_match = true }
end, { desc = 'telescope grep ruby' })

vim.keymap.set("n", "<leader>fk", telescope.keymaps, { desc = 'telescope keymaps' })

vim.keymap.set("n", "<leader>fq", function()
  telescope.find_files { cwd = '.notes/' }
end, { desc = "telescope find notes" })

vim.keymap.set("n", "<leader>fQ", function()
  telescope.live_grep{ cwd = '.notes/' }
end, { desc = "telescope grep notes" })

vim.keymap.set("n", "<leader>gb", function()
  telescope.git_branches{ show_remote_tracking_branches = false }
end, { desc = "telescope git branches" })

vim.keymap.set("n", "<leader>gT", function()
  telescope.git_files{}
end, { desc = "telescope git changed since master" })



vim.keymap.set("n", "Y", "y$", { desc = 'copy to end of line' } )
-- map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- copy file path

vim.keymap.set("n", "<leader>cp", [[<cmd>let @* = expand("%:~:.") | echo @*<cr>]], {desc = "Copy relative file path"})
vim.keymap.set("n", "<leader>cP", [[<cmd>let @* = expand("%:p") | echo @*<cr>]], {desc = "Copy absolute file path"})
vim.keymap.set("n", "<leader>cgp", [[<cmd>let @* = expand("%:~:.") . ':' . line('.') | echo @*<cr>]], {desc = "Copy relative file path:linenum"})

vim.keymap.set("n", "[c", function()
  require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true, desc = "Jump up to context" })

-- WIKI

-- opens quick notes file by calculating git branch name, using it as a filename and appending .md extension, in lua:
vim.keymap.set("n", "<leader>q", function()
  -- capture the output of a shell command
  local fname = ".notes/" .. string.gsub(vim.fn.system("git rev-parse --abbrev-ref HEAD"), "\n$", "") .. ".md"
  vim.cmd("e " .. fname)
end, { desc = "open current notes" })


-- copilot
vim.g.copilot_no_tab_map = true
vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})
vim.keymap.set('i', '<C-L>', '<Plug>(copilot-accept-word)')
--vim.keymap.set('i', '<C-K>', '<Plug>(copilot-panel-toggle)')

--[[
vim.keymap.set('i', '<M-J>', '<Plug>(copilot-accept-line)')
vim.keymap.set('i', '<M-L>', '<Plug>(copilot-accept-word)')
vim.keymap.set('i', '<M-H>', '<Plug>(copilot-dismiss)')
vim.keymap.set('i', '<M-K>', '<Plug>(copilot-panel-toggle)')
--]]

vim.keymap.set('n', '<leader>CC', ':Copilot status<CR>', { desc = 'Copilot status' })
vim.keymap.set('n', '<leader>Cd', ':Copilot disable<CR>', { desc = 'Copilot disable' })
vim.keymap.set('n', '<leader>Ce', ':Copilot enable<CR>', { desc = 'Copilot enable' })
vim.keymap.set('n', '<leader>Cp', ':Copilot panel<CR>', { desc = 'Copilot panel' })


vim.keymap.set('n', 'gK', function()
  local new_config = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = 'Toggle diagnostic virtual_lines' })


vim.keymap.set('n', 'zS', vim.show_pos, { desc = 'Inspect treesitter context' })
