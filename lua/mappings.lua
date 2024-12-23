-- ~/.local/share/nvchad/lazy/NvChad/lua/nvchad/mappings.lua
require "nvchad.mappings"

-- vim.keymap.set("n", ";", ":", { desc = "CMD enter command mode" })

vim.keymap.set("n", "<leader>.", ":e ~/.config/nvchad/init.lua<cr>", { desc = "Edit init.lua" })
vim.keymap.set("n", "<leader><leader>", "<cmd>Telescope find_files<cr>", { desc = "Telescope find files" })

vim.keymap.set("n", "Y", "y$")
-- map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
--
vim.keymap.set("n", "<leader>cp", [[<cmd>let @* = expand("%") | echo @*<cr>]], {desc = "Copy relative file path"})
vim.keymap.set("n", "<leader>cP", [[<cmd>let @* = expand("%:p") | echo @*<cr>]], {desc = "Copy absolute file path"})
vim.keymap.set("n", "<leader>cgp", [[<cmd>let @* = expand("%") . ':' . line('.') | echo @*<cr>]], {desc = "Copy relative file path:linenum"})

vim.keymap.set("n", "[c", function()
  require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true, desc = "Jump up to context" })

-- opens quick notes file by calculating git branch name, using it as a filename and appending .md extension, in lua:
vim.keymap.set("n", "<leader>q", function()
  -- capture the output of a shell command
  local fname = "notes/" .. string.gsub(vim.fn.system("git rev-parse --abbrev-ref HEAD"), "\n$", "") .. ".md"
  vim.cmd("e " .. fname)
end, { desc = "Open quick notes" })
