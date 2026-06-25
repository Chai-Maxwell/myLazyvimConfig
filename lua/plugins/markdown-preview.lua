-- ~/.config/nvim/lua/plugins/markdown_preview.lua
return {
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    config = function()
      -- ===== 关键设置 =====
      vim.g.mkdp_auto_close = 0   -- 切换 buffer 时不关闭浏览器预览
      vim.g.mkdp_refresh_slow = 0 -- 保存文件时自动刷新预览
      vim.g.mkdp_auto_start = 0   -- 打开 .md 时不自动启动预览（按需手动 :MarkdownPreview）

      local function set_css()
        local cwd = vim.fn.getcwd()
        local css = cwd .. "/.crossnote/style.css"

        if vim.fn.filereadable(css) == 1 then
          vim.g.mkdp_markdown_css = css
        else
          vim.g.mkdp_markdown_css = ""
        end
      end

      -- 初始设置
      set_css()

      -- 进入 markdown 时更新
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = set_css,
      })

      -- 切换工作目录时更新（可选但推荐）
      vim.api.nvim_create_autocmd("DirChanged", {
        callback = set_css,
      })
    end,
  },
}
