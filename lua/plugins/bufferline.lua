-- ~/.config/nvim/lua/plugins/bufferline.lua
--
-- 替换 lualine 的 tabline，用 bufferline 管理标签栏
-- 暖纸透明风，与 colorscheme.lua / lualine.lua 色调一致
-- keys / config 由 LazyVim 默认管理，这里只覆盖 opts

return {
  "akinsho/bufferline.nvim",
  opts = {
    options = {
      -- 始终显示标签栏（即使只有一个 buffer）
      always_show_bufferline = true,

      -- 序号模式：ordinal = 按位置顺序 1,2,3…（关闭后自动重排）
      numbers = "ordinal",
      -- 当前选中 buffer 左侧指示器
      indicator = {
        style = "underline",
      },

      -- 分隔线风格
      separator_style = "thin",

      -- 诊断信息
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(_, _, diag)
        local icons = {
          error = "● ",
          warning = "▲ ",
          info = "◆ ",
        }
        local ret = (diag.error and icons.error .. diag.error .. " " or "")
          .. (diag.warning and icons.warning .. diag.warning or "")
        return vim.trim(ret)
      end,

      -- 关闭按钮行为
      close_command = function(n)
        require("snacks").bufdelete(n)
      end,
      right_mouse_command = function(n)
        require("snacks").bufdelete(n)
      end,

      -- buffer 排序
      sort_by = "insert_at_end",

      -- Neo-tree 侧边栏偏移
      offsets = {
        {
          filetype = "neo-tree",
          text = "Files",
          highlight = "Directory",
          text_align = "left",
        },
        {
          filetype = "snacks_layout_box",
        },
      },

      -- 排除 quickfix 等特殊 buffer
      custom_filter = function(bufnr)
        local bt = vim.bo[bufnr].buftype
        return bt ~= "quickfix" and bt ~= "nofile"
      end,
    },

    -- ══════════════════════════════════════════════════════════
    -- 高亮组 — 透明底 + 暖纸色系
    -- ══════════════════════════════════════════════════════════
    highlights = {
      -- 标签栏整体填充 — 透明
      fill = {
        fg = "#111111",
        bg = "NONE",
      },

      -- 分隔线
      separator = {
        fg = "#DCB48C",
        bg = "NONE",
      },

      -- 选中的标签
      buffer_selected = {
        fg = "#111111",
        bg = "#DCB48C",
        bold = false,
        italic = false,
      },

      -- 未选中的标签
      buffer_visible = {
        fg = "#A1551A",
        bg = "NONE",
        italic = false,
      },

      -- buffer 序号
      numbers = {
        fg = "#dcdddd",
        bg = "NONE",
      },
      numbers_selected = {
        fg = "#111111",
        bg = "#DCB48C",
        bold = true,
      },
      numbers_visible = {
        fg = "#A1551A",
        bg = "NONE",
      },

      -- 诊断信息
      diagnostic = {
        fg = "#565f89",
        bg = "NONE",
      },
      diagnostic_selected = {
        fg = "#565f89",
        bg = "#DCB48C",
      },

      -- 修改标记 ●
      modified = {
        fg = "#e0af68",
        bg = "NONE",
      },
      modified_selected = {
        fg = "#e0af68",
        bg = "#DCB48C",
      },

      -- 重复 buffer 名
      duplicate = {
        fg = "#dcdddd",
        bg = "NONE",
      },
      duplicate_selected = {
        fg = "#111111",
        bg = "#DCB48C",
      },

      -- 标签分隔符
      separator_selected = {
        fg = "#DCB48C",
        bg = "#DCB48C",
      },
      separator_visible = {
        fg = "NONE",
        bg = "NONE",
      },

      -- 关闭按钮
      close_button = {
        fg = "#f7768e",
        bg = "NONE",
      },
      close_button_selected = {
        fg = "#f7768e",
        bg = "#DCB48C",
      },
      close_button_visible = {
        fg = "#A1551A",
        bg = "NONE",
      },

      -- 拾取 buffer 时的颜色
      pick = {
        fg = "#111111",
        bg = "#ffee99",
        bold = true,
      },
      pick_selected = {
        fg = "#111111",
        bg = "#ffee99",
        bold = true,
      },

      -- 偏移区（neo-tree 标签）
      offset_separator = {
        fg = "#DCB48C",
        bg = "NONE",
      },

      -- 提示文本
      hint = {
        fg = "#dcdddd",
        bg = "NONE",
        italic = true,
      },
      hint_selected = {
        fg = "#dcdddd",
        bg = "#DCB48C",
        italic = true,
      },

      -- 截断标记 …
      trunc_marker = {
        fg = "#dcdddd",
        bg = "NONE",
      },
    },
  },
}
