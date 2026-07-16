-- ~/.config/nvim/lua/plugins/latex.lua
-- LaTeX support: texlab LSP + latexindent formatting via conform.nvim
return {
  -- texlab LSP (completions, diagnostics, forward/reverse search)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        texlab = {},
      },
    },
  },

  -- install texlab via mason
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "texlab",
      },
    },
  },

  -- use latexindent for .tex formatting via conform.nvim (LazyVim handles format-on-save)
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        tex = { "latexindent" },
      },
      formatters = {
        latexindent = {
          -- macOS 优先使用 Homebrew 安装的版本，否则用 PATH 中的
          command = require("config.platform").latexindent_cmd(),
        },
      },
    },
  },
}
