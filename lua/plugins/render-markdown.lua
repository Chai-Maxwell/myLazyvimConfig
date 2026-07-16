-- ~/.config/nvim/lua/plugins/render-markdown.lua
-- 覆盖 LazyVim markdown extra 中的 render-markdown.nvim 配置
--
-- 关闭 LaTeX 数学公式的内联渲染：
--   该文件的 inline math 密度是其他 .md 的 3-5 倍（113 vs 22 个 span），
--   render-markdown 需要为每个 $...$ 和 $$...$$ 创建 extmarks/virtual text，
--   导致光标移动和编辑显著变慢。
--   关闭后，数学公式保持原样（$...$），不影响阅读和编辑。
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      latex = {
        enabled = false, -- 关闭 LaTeX 数学渲染
      },
    },
  },
}
