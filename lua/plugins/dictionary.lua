-- 英文词典补全：候选来自系统词表，而不只是当前 buffer
return {
  {
    "saghen/blink.cmp",
    dependencies = { "Kaiser-Yang/blink-cmp-dictionary" },
    opts = function(_, opts)
      table.insert(opts.sources.default, "dictionary")
      opts.sources.providers.dictionary = {
        module = "blink-cmp-dictionary",
        name = "Dict",
        min_keyword_length = 3, -- 敲够 3 个字母才查词典，避免写作时干扰
        score_offset = -2, -- 略低于 LSP/buffer
        enabled = function()
          -- 只在写作用途的 filetype 里启用；想全局启用就删掉这个函数
          return vim.tbl_contains({ "markdown", "text", "tex", "gitcommit" }, vim.bo.filetype)
        end,
        opts = {
          -- 17 万词：4.7 万常用词 + 2023 年英文维基词频 top 20 万（合并去重）
          dictionary_files = { vim.fn.expand("~/.config/nvim/dictionary/words.txt") },
          -- 想要生僻词时可以把系统词典加回来（会变慢）：
          -- { "/usr/share/dict/words" },
          -- 或者把一个目录下所有 .txt 当词典：
          -- dictionary_directories = { vim.fn.expand("~/.config/nvim/dictionary") },
        },
      }
    end,
  },
}
