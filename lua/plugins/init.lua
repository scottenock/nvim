return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    cmd = { "ConformInfo" },
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "configs.lint"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "yaml",
        "terraform",
        "javascript",
        "typescript",
        "tsx",
        "go",
        "gomod",
        "gosum",
        "gotmpl",
        "gowork",
      },
    },
  },

  {
    "rhysd/conflict-marker.vim",
    event = "VeryLazy", -- or choose a better event if you prefer
    config = function()
      -- Disable default highlight group
      vim.g.conflict_marker_highlight_group = ""

      -- Customize regex patterns for conflict markers (optional)
      vim.g.conflict_marker_begin = "^<<<<<<<\\+ .*$"
      vim.g.conflict_marker_common_ancestors = "^|||||||\\+ .*$"
      vim.g.conflict_marker_end = "^>>>>>>>\\+ .*$"

      -- Define your own highlight groups
      vim.api.nvim_set_hl(0, "ConflictMarkerBegin", { bg = "#2f7366" })
      vim.api.nvim_set_hl(0, "ConflictMarkerOurs", { bg = "#2e5049" })
      vim.api.nvim_set_hl(0, "ConflictMarkerTheirs", { bg = "#344f69" })
      vim.api.nvim_set_hl(0, "ConflictMarkerEnd", { bg = "#2f628e" })
      vim.api.nvim_set_hl(0, "ConflictMarkerCommonAncestorsHunk", { bg = "#754a81" })
    end,
  },

  {
    "davidmh/mdx.nvim",
    config = true,
    lazy = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },

}
