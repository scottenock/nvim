local lint = require("lint")

lint.linters_by_ft = {
  go = { "golangcilint" },
  terraform = { "tflint" },
}

vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
  callback = function()
    require("lint").try_lint()
  end,
})

-- Manual trigger
vim.keymap.set("n", "<leader>li", function()
  lint.try_lint()
end, { desc = "Trigger linting" })


vim.keymap.set("n", "<leader>lb", function()
  local golang = lint.linters.golangcilint
  local args = golang.args
  local final_args = {}
  for _, v in ipairs(args) do
    if type(v) == "function" then
      table.insert(final_args, v())
    else
      table.insert(final_args, v)
    end
  end

  print("nvim-lint would run:")
  print("golangci-lint " .. table.concat(final_args, " "))
  lint.try_lint()
end, { desc = "Trigger linting (with debug)" })

-- Info command
vim.api.nvim_create_user_command("LintInfo", function()
  local filetype = vim.bo.filetype
  local linters = lint.linters_by_ft[filetype]

  if linters then
    print("Linters for " .. filetype .. ": " .. table.concat(linters, ", "))
  else
    print("No linters configured for filetype: " .. filetype)
  end
end, {})
