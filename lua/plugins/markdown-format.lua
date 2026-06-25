return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters = {
        ["markdownlint-cli2"] = {
          -- 总是运行 markdownlint-cli2，不再依赖已有的诊断
          condition = function()
            return true
          end,
        },
      },
      formatters_by_ft = {
        -- 移除 prettier：prettier 不支持配置 emphasis 样式，会将 *italic* 转换为 _italic_
        ["markdown"] = { "markdownlint-cli2", "markdown-toc" },
        ["markdown.mdx"] = { "markdownlint-cli2", "markdown-toc" },
      },
    },
  },
}
