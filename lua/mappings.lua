require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("i", "jk", "<ESC>")

vim.api.nvim_create_user_command("ClearBuffers", "bufdo if !&modified | bdelete | endif", {})
map("n", "<leader>zz", ":ClearBuffers<CR>", { noremap = true })
map("n", "<leader>ef", ":EslintFixAll<CR>", { noremap = true })
map("x", "<leader>p", '"_dP', { noremap = true, desc = "Paste without overwriting yank" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
})

-- Search and replace with capital and lowercase
vim.api.nvim_create_user_command("ReplaceAllCase", function()
  local search = vim.fn.input "Search for (lowercase): "
  if search == "" then
    return
  end
  local replace = vim.fn.input "Replace with (lowercase): "
  if replace == "" then
    return
  end

  -- Capitalize first letter
  local function capitalize(str)
    return str:sub(1, 1):upper() .. str:sub(2)
  end

  -- Do replacements, ignoring errors if pattern not found
  pcall(vim.cmd, "%s/" .. capitalize(search) .. "/" .. capitalize(replace) .. "/g")
  pcall(vim.cmd, "%s/" .. search .. "/" .. replace .. "/g")
end, {
  desc = "Replace all occurrences with capitalized and lowercase forms",
})

-- Optional mapping
map("n", "<leader>rac", ":ReplaceAllCase<CR>", { noremap = true, desc = "Replace all with case variants" })
