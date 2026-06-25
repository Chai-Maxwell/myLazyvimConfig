return {
  -- 1. D2 官方插件：语法高亮 + 自动缩进 + 文件类型检测
  {
    "terrastruct/d2-vim",
    ft = "d2",
  },

  -- 2. Tree-sitter 解析器（更精准的语义高亮）
  {
    "ravsii/tree-sitter-d2",
    ft = "d2",
    -- 编译 C parser + 修复 queries 目录结构
    build = function()
      local dir = vim.fn.stdpath("data") .. "/lazy/tree-sitter-d2"
      -- 编译 parser.c → d2.so
      vim.fn.system({
        "cc", "-shared", "-fPIC", "-o", dir .. "/d2.so",
        "-I", dir .. "/src",
        dir .. "/src/parser.c",
      })
      -- 复制到 Neovim 全局 parser 目录
      local parser_dir = vim.fn.stdpath("data") .. "/site/parser"
      vim.fn.mkdir(parser_dir, "p")
      vim.fn.system({ "cp", dir .. "/d2.so", parser_dir .. "/d2.so" })
      -- 修复: queries 需在 queries/d2/ 下 Neovim 才能找到
      local qdir = dir .. "/queries/d2"
      vim.fn.mkdir(qdir, "p")
      for _, f in ipairs({ "highlights.scm", "folds.scm", "injections.scm", "locals.scm" }) do
        local src = dir .. "/queries/" .. f
        local dst = qdir .. "/" .. f
        if vim.fn.filereadable(src) == 1 and vim.fn.filereadable(dst) ~= 1 then
          vim.fn.system({ "ln", "-sf", src, dst })
        end
      end
      vim.notify("d2: tree-sitter parser ready", vim.log.levels.INFO)
    end,
    config = function()
      -- 清除插件自带的 FileType autocmd，它在 Neovim 0.11+ 中调用了
      -- 已被移除的 vim.treesitter.start()，会导致每次打开 .d2 报错
      pcall(vim.api.nvim_clear_autocmds, {
        event = "FileType",
        pattern = "d2",
      })

      -- 用新版 API 正确注册 treesitter language → filetype 映射
      local ok, err = pcall(vim.treesitter.language.register, "d2", "d2")
      if not ok then
        vim.notify("d2: treesitter register failed: " .. tostring(err), vim.log.levels.WARN)
      end

      -- 注册 :D2Png 命令（编译当前 .d2 → 同名 .png）
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "d2",
        callback = function(args)
          vim.api.nvim_buf_create_user_command(args.buf, "D2Png", function()
            local buf = vim.api.nvim_get_current_buf()
            local file = vim.api.nvim_buf_get_name(buf)
            if file == "" then
              vim.notify("D2Png: 当前 buffer 未关联文件，请先保存", vim.log.levels.WARN)
              return
            end
            if not file:match("%.d2$") then
              vim.notify("D2Png: 当前文件不是 .d2 文件", vim.log.levels.WARN)
              return
            end
            local png = file:gsub("%.d2$", ".png")
            local name = vim.fn.fnamemodify(file, ":t")
            local pngname = vim.fn.fnamemodify(png, ":t")
            vim.notify("D2Png: 正在编译 " .. name .. " ...", vim.log.levels.INFO)
            vim.cmd("write")
            -- 使用 jobstart 异步执行，不阻塞 UI
            local stderr = {}
            vim.fn.jobstart({ "d2", file, png }, {
              on_stderr = function(_, data)
                if data then
                  vim.list_extend(stderr, data)
                end
              end,
              on_exit = function(_, exit_code)
                if exit_code == 0 then
                  vim.notify("D2Png: 已生成 " .. pngname, vim.log.levels.INFO)
                else
                  local msg = "D2Png: 编译失败"
                  if #stderr > 0 then
                    msg = msg .. "\n" .. table.concat(stderr, "\n")
                  end
                  vim.notify(msg, vim.log.levels.ERROR)
                end
              end,
            })
          end, { desc = "Compile current .d2 to .png (async)" })
        end,
      })
    end,
  },
}
