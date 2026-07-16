-- ~/.config/nvim/lua/plugins/oil.lua
--
-- ╔══════════════════════════════════════════════════════════════╗
-- ║     🛢️  Oil.nvim · 浮动文件管理器                           ║
-- ║                                                              ║
-- ║  核心理念：目录 = 可编辑的文本 buffer                        ║
-- ║  · 创建文件 → 新加一行文字                                  ║
-- ║  · 重命名   → 编辑文件名（跟改文字一样）                      ║
-- ║  · 删除     → dd 标记，:w 时统一确认后移入垃圾桶             ║
-- ║  · 移动     → dd 剪切，到目标目录 p 粘贴                      ║
-- ╚══════════════════════════════════════════════════════════════╝

return {
  "stevearc/oil.nvim",
  keys = {
    {
      "<leader>e",
      function()
        require("oil").open_float()
      end,
      desc = "Open file manager (Oil)",
    },
  },
  opts = {
    -- 删除 → macOS 垃圾桶（与 neo-tree 行为一致）
    delete_to_trash = true,
    -- 简单操作（创建/改名）跳过确认弹窗
    skip_confirm_for_simple_edits = true,
    -- 选择新建/移动的文件时提示
    prompt_save_on_select_new_entry = true,
    -- 浮动窗口（Telescope 风格：居中 + 圆角 + 80% 屏幕）
    float = {
      padding = 2,
      border = "rounded",
      max_width = 0,  -- 由 override 动态计算
      max_height = 0,
      override = function(conf)
        -- Telescope 风格：居中，占屏幕 80%
        local width = math.floor(vim.o.columns * 0.8)
        local height = math.floor((vim.o.lines - vim.o.cmdheight) * 0.8)
        conf.width = width
        conf.height = height
        conf.row = math.floor(((vim.o.lines - vim.o.cmdheight) - height) / 2)
        conf.col = math.floor((vim.o.columns - width) / 2)
        return conf
      end,
    },
    view_options = {
      show_hidden = true,
    },
    keymaps = {
      ["q"] = "actions.close",
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["`"] = "actions.cd",
      ["~"] = "actions.tcd",
      ["gs"] = "actions.change_sort",
      ["gx"] = "actions.open_external",
      ["g."] = "actions.toggle_hidden",
      ["g\\"] = "actions.toggle_trash",
    },
  },
  dependencies = {
    { "nvim-mini/mini.icons", opts = {} },
  },
}
