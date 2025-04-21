local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    go = { "gofumpt" },
    markdown = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier", stop_after_first = true },
    javascriptreact = { "prettier", stop_after_first = true },
    typescriptreact = { "eslint", "prettier", stop_after_first = true },
    graphql = { "prettier", stop_after_first = true },
    json = { "prettier" },
  },

  formatters = {},

  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
