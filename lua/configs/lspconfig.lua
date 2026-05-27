require("nvchad.configs.lspconfig").defaults()

local servers = {
  "html",
  "gopls",
  "pyright",
  "ts_ls",
  "eslint",
  "tailwindcss",
  "emmet_language_server",
  "cssls",
  "terraformls",
  "phpactor",
}
vim.lsp.config.gopls = {
  filetypes = { "go" },
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

vim.lsp.enable(servers)

vim.api.nvim_create_user_command("EslintFixAll", function()
  local clients = vim.lsp.get_clients({ name = "eslint", bufnr = 0 })
  for _, client in ipairs(clients) do
    client:request("workspace/executeCommand", {
      command = "eslint.applyAllFixes",
      arguments = { { uri = vim.uri_from_bufnr(0), version = vim.lsp.util.buf_versions[0] } },
    }, nil, 0)
  end
end, {})

-- read :h vim.lsp.config for changing options of lsp servers
