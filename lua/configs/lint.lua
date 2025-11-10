local lint = require("lint")

-- Define a proper golangci-lint integration
lint.linters.golangcilint = {
  cmd = "golangci-lint",
  stdin = false,
  append_fname = false,
  args = {
    "run",
    "--out-format", "json",
    "--path-prefix", vim.fn.getcwd(),
  },
  ignore_exitcode = true,
  parser = function(output, _)
    local ok, decoded = pcall(vim.json.decode, output)
    if not ok or not decoded or not decoded.Issues then
      return {}
    end

    local diagnostics = {}
    for _, issue in ipairs(decoded.Issues) do
      table.insert(diagnostics, {
        lnum = issue.Pos.Line - 1,
        col = issue.Pos.Column - 1,
        end_lnum = issue.Pos.EndLine and issue.Pos.EndLine - 1 or issue.Pos.Line - 1,
        end_col = issue.Pos.EndColumn or issue.Pos.Column,
        severity = vim.diagnostic.severity.WARN,
        source = "golangci-lint",
        message = string.format("[%s] %s", issue.FromLinter, issue.Text),
      })
    end
    return diagnostics
  end,
}

lint.linters_by_ft = {
  go = { "golangcilint" },
  terraform = { "tflint" },
}

-- Auto-run lint on common events
vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
  callback = function()
    local ft = vim.bo.filetype
    if lint.linters_by_ft[ft] then
      lint.try_lint()
    end
  end,
})

-- Manual trigger (leader + li)
vim.keymap.set("n", "<leader>li", function()
  lint.try_lint()
end, { desc = "Trigger linting for current file" })

vim.api.nvim_create_user_command("LintInfo", function()
  local filetype = vim.bo.filetype
  local linters = lint.linters_by_ft[filetype]

  if linters then
    print("Linters for " .. filetype .. ": " .. table.concat(linters, ", "))
  else
    print("No linters configured for filetype: " .. filetype)
  end
end, {})
