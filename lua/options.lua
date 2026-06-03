require "nvchad.options"

vim.opt.runtimepath:append(vim.fn.stdpath "data" .. "/site")

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
vim.opt.relativenumber = true
vim.opt.colorcolumn = "120"
vim.opt.title = true
vim.opt.titlestring = "%{fnamemodify(getcwd(), ':t')} — nvim"
