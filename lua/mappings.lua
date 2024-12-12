require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("i", "jk", "<ESC>")

vim.api.nvim_create_user_command("ClearBuffers", "bufdo if !&modified | bdelete | endif", {})
map("n", "<leader>zz", ":ClearBuffers<CR>", { noremap = true })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
