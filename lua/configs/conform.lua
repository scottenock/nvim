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

  formatters = {},

  format_on_save = function(bufnr)
    -- Disable with a global or buffer-local variable
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 500, lsp_format = "fallback" }
  end,
}

return options
