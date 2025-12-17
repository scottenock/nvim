require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "gopls", "ts_ls", "eslint", "tailwindcss", "emmet_language_server", "cssls", "terraformls", "phpactor" }
vim.lsp.enable(servers)

vim.lsp.config.gopls = {
 filetypes = {"go"},
 settings = {
    gopls = {
      gofumpt = true,
      analyses = {
        unusedparams = true,
        nilness = true,
        unusedwrite = true,
      },
      staticcheck = true,
      usePlaceholders = true,
      completeUnimported = true,
    },
  },
}

-- read :h vim.lsp.config for changing options of lsp servers 
