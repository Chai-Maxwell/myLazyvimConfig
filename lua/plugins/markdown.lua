-- lua/plugins/markdown.lua
return {
  "iamcco/markdown-preview.nvim",
  ft = "markdown", -- 只对 markdown 文件类型加载
  build = "cd app && npm install", -- 重要：首次安装需要编译
  config = function()
    -- 在 macOS 上必须使用绝对路径
    local config_dir = vim.fn.expand("~/.config/nvim")

    -- 设置自定义 CSS 文件路径
    vim.g.mkdp_markdown_css = config_dir .. "/markdown.css" -- 正文样式
    vim.g.mkdp_highlight_css = config_dir .. "/highlight.css" -- 代码高亮样式
  end,
}
