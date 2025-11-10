local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    go = { "gofumpt" },
    markdown = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier", stop_after_first = true },
    javascriptreact = { "prettier", stop_after_first = true },
    typescriptreact = { "prettier", stop_after_first = true },
    graphql = { "prettier", stop_after_first = true },
    json = { "prettier" },
  },
  format_on_save = {
    timeout_ms = 2000,
    lsp_fallback = true,
  },
}
return options
