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
          -- 使用 Homebrew 安装的版本（TeX Live 自带版缺少 Perl 依赖会崩溃）
          command = "/opt/homebrew/bin/latexindent",
        },
      },
    },
  },
}
