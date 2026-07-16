-- ~/.config/nvim/lua/plugins/lualine.lua
--
-- ╔══════════════════════════════════════════════════════════════╗
-- ║        🎨  Warm Paper Lualine · 暖纸风格状态栏               ║
-- ║                                                              ║
-- ║  Section 布局：a b c … x y z                                  ║
-- ║    a ─ 模式名（带图标）                                       ║
-- ║    b ─ 分支 / diff / 诊断                                     ║
-- ║    c ─ 文件名 / LSP 客户端名 / 宏录制                          ║
-- ║    x ─ LSP 状态 / 文件类型 / 编码                              ║
-- ║    y ─ 进度 / 搜索计数                                        ║
-- ║    z ─ 光标位置                                               ║
-- ║                                                              ║
-- ║  模式色：Normal=鹅黄  Insert=嫩绿  Visual=淡青                 ║
-- ║          Replace=朱红  Terminal=夏日橘                         ║
-- ╚══════════════════════════════════════════════════════════════╝

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function(_, opts)
    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  调色板 · Palette（与 colorscheme.lua 同步）                 ║
    -- ╚══════════════════════════════════════════════════════════════╝
    local brown = "#DCB48C"
    local plant_green = "#d6df89"
    local red = "#D2442D"
    local pale_blue = "#9dd6d8"
    local summer_orange = "#ffa488"
    local pale_yellow = "#ffee99"
    local fg = "#000000"

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  【1. theme】各模式 section 颜色                             ║
    -- ║                                                              ║
    -- ║  a = 模式区（mode 色底 + dark 字）                           ║
    -- ║  b/c/x = 信息区（brown 底 + dark 字）                        ║
    -- ║  y/z = 位置区（与 mode 同色底，首尾呼应）                    ║
    -- ║  非活跃窗口 → brown 焦糖底                                  ║
    -- ╚══════════════════════════════════════════════════════════════╝
    opts.options.theme = {
      normal = {
        a = { bg = pale_yellow, fg = fg, bold = true },
        b = { bg = brown, fg = fg },
        c = { bg = brown, fg = fg },
        x = { bg = brown, fg = fg },
        y = { bg = pale_yellow, fg = fg },
        z = { bg = pale_yellow, fg = fg },
      },
      insert = {
        a = { bg = plant_green, fg = fg, bold = true },
        b = { bg = brown, fg = fg },
        c = { bg = brown, fg = fg },
        x = { bg = brown, fg = fg },
        y = { bg = plant_green, fg = fg },
        z = { bg = plant_green, fg = fg },
      },
      visual = {
        a = { bg = pale_blue, fg = fg, bold = true },
        b = { bg = brown, fg = fg },
        c = { bg = brown, fg = fg },
        x = { bg = brown, fg = fg },
        y = { bg = pale_blue, fg = fg },
        z = { bg = pale_blue, fg = fg },
      },
      replace = {
        a = { bg = red, fg = fg, bold = true },
        b = { bg = brown, fg = fg },
        c = { bg = brown, fg = fg },
        x = { bg = brown, fg = fg },
        y = { bg = red, fg = fg },
        z = { bg = red, fg = fg },
      },
      terminal = {
        a = { bg = summer_orange, fg = fg, bold = true },
        b = { bg = brown, fg = fg },
        c = { bg = brown, fg = fg },
        x = { bg = brown, fg = fg },
        y = { bg = summer_orange, fg = fg },
        z = { bg = summer_orange, fg = fg },
      },
      inactive = {
        -- 仅文件名区域保留 brown 底色，其余透明
        a = { bg = "NONE", fg = fg },
        b = { bg = "NONE", fg = fg },
        c = { bg = "NONE", fg = fg },
        x = { bg = "NONE", fg = fg },
        y = { bg = "NONE", fg = fg },
        z = { bg = "NONE", fg = fg },
      },
      -- tabline 单独设为透明底
      tabline = {
        a = { bg = "NONE", fg = fg },
        b = { bg = "NONE", fg = fg },
        c = { bg = "NONE", fg = fg },
        x = { bg = "NONE", fg = fg },
        y = { bg = "NONE", fg = fg },
        z = { bg = "NONE", fg = fg },
      },
    }

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  【2. mode】模式名替换为图标 + 文字                          ║
    -- ╚══════════════════════════════════════════════════════════════╝
    local mode_icons = {
      n = "NORMAL",
      no = "N·OP",
      nov = "N·OP",
      noV = "N·OP",
      ["no\22"] = "N·OP",
      niI = "N·I",
      niR = "N·R",
      niV = "N·V",
      i = "INSERT",
      ic = "I·C",
      ix = "I·X",
      v = "VISUAL",
      V = "V·LINE",
      ["\22"] = "V·BLOCK",
      s = "SELECT",
      S = "S·LINE",
      R = "REPLACE",
      Rc = "R·C",
      Rv = "R·V",
      t = "TERM",
      c = "COMMAND",
      ["!"] = "SHELL",
    }

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  【3. sections】组件布局                                     ║
    -- ╚══════════════════════════════════════════════════════════════╝
    opts.sections = {
      lualine_a = {
        {
          "mode",
          fmt = function(str)
            return mode_icons[str] or str:upper()
          end,
        },
      },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {
        {
          function()
            -- LSP 客户端名
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients == 0 then
              return ""
            end
            local names = {}
            for _, client in ipairs(clients) do
              table.insert(names, client.name)
            end
            return "⚡ " .. table.concat(names, ", ")
          end,
          color = { fg = "#4F8CF9" },
        },
        "filetype",
        "encoding",
      },
      lualine_y = {
        "progress",
        {
          "searchcount",
          maxcount = 999,
          timeout = 500,
        },
      },
      lualine_z = {
        "location",
      },
    }

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  【4. inactive_sections】非当前窗口内容                      ║
    -- ╚══════════════════════════════════════════════════════════════╝
    opts.inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = { "filetype" },
      lualine_y = {},
      lualine_z = { "location" },
    }

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  【5. winbar】窗口顶部栏（面包屑导航）                       ║
    -- ╚══════════════════════════════════════════════════════════════╝
    opts.winbar = {
      lualine_a = {
        {
          "filename",
          path = 1,
          shorting_target = 60,
          symbols = {
            modified = "[+]",
            readonly = "[r]",
            unnamed = "[No Name]",
          },
        },
      },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = { "branch" },
    }

    opts.inactive_winbar = {
      lualine_a = { "filename" },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = { "branch" },
    }

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  【6. tabline】标签栏（已关闭）                              ║
    -- ╚══════════════════════════════════════════════════════════════╝
    -- opts.tabline = {
    --   lualine_a = {
    --     {
    --       "buffers",
    --       mode = 2,
    --       symbols = {
    --         modified = " ●",
    --         alternate_file = "",
    --         directory = "📁",
    --       },
    --     },
    --   },
    --   lualine_b = {},
    --   lualine_c = {},
    --   lualine_x = {},
    --   lualine_y = {},
    --   lualine_z = { "branch" },
    -- }

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  【7. separators】分段符                                     ║
    -- ╚══════════════════════════════════════════════════════════════╝
    opts.options.section_separators = {
      left = "", -- a→b, b→c
      right = "", -- x←y, y←z
    }
    opts.options.component_separators = {
      left = "/",
      right = "/",
    }

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  【8. extensions】扩展支持                                   ║
    -- ╚══════════════════════════════════════════════════════════════╝
    opts.extensions = {
      "fugitive", -- vim-fugitive git 操作
      -- neo-tree 已移除：其 statusline 会继承 lualine 的分隔符，造成视觉污染
      "trouble", -- 诊断列表
      "lazy", -- 插件管理
      "mason", -- LSP 安装器
      "quickfix", -- Quickfix / Location list
      "toggleterm", -- 浮动终端
    }

    -- ╔══════════════════════════════════════════════════════════════╗
    -- ║  【9. options】全局选项                                      ║
    -- ╚══════════════════════════════════════════════════════════════╝
    opts.options.globalstatus = true -- 全局唯一状态栏（推荐）
    opts.options.always_divide_middle = true -- c 和 x 之间强制分隔
    opts.options.icons_enabled = true -- 显示图标
    opts.options.refresh = {
      statusline = 100,
      tabline = 1000,
      winbar = 1000,
    }
    opts.options.disabled_filetypes = {
      "alpha",
      "dashboard",
      "snacks_dashboard",
    }
  end,
}
