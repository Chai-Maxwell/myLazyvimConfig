-- 英文词典补全：候选来自系统词表，而不只是当前 buffer
return {
  {
    "saghen/blink.cmp",
    dependencies = { "Kaiser-Yang/blink-cmp-dictionary" },
    opts = function(_, opts)
      table.insert(opts.sources.default, "dictionary")
      -- 用本机已有的 Rust 模糊匹配库：排序更准，并启用 blink 内建的 frecency
      -- （按本地接受记录加权，本地常用词优先）
      opts.fuzzy = vim.tbl_deep_extend("force", opts.fuzzy or {}, {
        implementation = "prefer_rust",
        prebuilt_binaries = { ignore_version_mismatch = true },
      })
      -- 补全菜单最右端显示本地使用次数。blink 内建的 frecency 存在 Rust 二进制里、
      -- Lua 读不到，所以由 dict_freq_source 另外记录一份可读的接受次数。
      opts.completion = opts.completion or {}
      opts.completion.menu = opts.completion.menu or {}
      opts.completion.menu.draw = opts.completion.menu.draw or {}
      local draw = opts.completion.menu.draw
      draw.columns = {
        { "kind_icon" },
        { "label", "label_description", gap = 1 },
        { "dict_local_freq" },
      }
      draw.components = vim.tbl_deep_extend("force", draw.components or {}, {
        dict_local_freq = {
          ellipsis = false,
          text = function(ctx)
            if ctx.item.source_id ~= "dictionary" then return "" end
            local count = require("dict_freq_source").local_count(ctx.item.label)
            if count == 0 then return "" end
            return string.format("%3d", count) -- 右对齐，最多显示 3 位
          end,
          highlight = "BlinkCmpSource",
        },
      })
      opts.sources.providers.dictionary = {
        module = "dict_freq_source",
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
