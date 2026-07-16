return {
  {
    "stevearc/conform.nvim",
    optional = true,
    ---@param opts conform.setupOpts
    opts = function(_, opts)
      -- 再次移除 prettier（prettier extra 的 function opts 会把它加回来）
      -- prettier 会将 *italic* 转换为 _italic_，且不支持配置 emphasis 样式
      -- prettier 还会把有序列表 1. 2. 3. 统一改成 1. 1. 1.
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft["markdown"] = { "markdownlint-cli2", "markdown-toc" }
      opts.formatters_by_ft["markdown.mdx"] = { "markdownlint-cli2", "markdown-toc" }

      -- markdownlint-cli2 由 nvim-lint 诊断触发，不再无条件运行
      -- （恢复 LazyVim 默认行为：仅当缓冲区已有 markdownlint 诊断时才格式化）
    end,
  },
}
