-- ~/.config/nvim/lua/plugins/colorscheme.lua
return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = function()
      -- 颜色常量
      local colors = {
        brown = "#DCB48C",
        gray = "#A1551A",
        dark_gray = "#195591",
        black = "#000000",
        dark_black = "#222222",
        light_gray = "#CCCCCC",
      }

      -- 工具函数
      local function transparent_bg()
        return { bg = "NONE" }
      end

      local function black_fg()
        return { fg = colors.black }
      end

      local function selection_highlight()
        return { bg = colors.brown, fg = colors.black }
      end

      -- 透明背景的组列表
      local transparent_groups = {
        "Normal",
        "NormalNC",
        "NormalFloat",
        "FloatBorder",
        "FloatTitle",
        "SignColumn",
        "EndOfBuffer",
        "FoldColumn",
        "CursorColumn",
        "MsgArea",
        "MsgSeparator",
        "WinSeparator",
        "StatusLine",
        "StatusLineNC",
        "TabLine",
        "TabLineFill",
        "TabLineSel",
        "WinBar",
        "WinBarNC",
        "Pmenu",
        "PmenuSbar",
        "PmenuThumb",
      }

      return {
        style = "night",
        transparent = true,
        styles = {
          sidebars = "transparent",
          floats = "transparent",
        },

        on_highlights = function(hl, c)
          -- =========================
          -- 1. 全局透明背景
          -- =========================
          for _, group in ipairs(transparent_groups) do
            hl[group] = transparent_bg()
          end

          -- =========================
          -- 2. 光标 / 行 / 选区
          -- =========================
          hl.CursorLine = transparent_bg()
          hl.CursorLineNr = { fg = colors.brown, bold = true }
          hl.LineNr = { fg = colors.gray }

          -- 所有选区相关的高亮
          local selection_groups = {
            "Visual",
            "VisualNOS",
            "Search",
            "IncSearch",
            "CurSearch",
            "Substitute",
            "MatchParen",
          }

          for _, group in ipairs(selection_groups) do
            hl[group] = selection_highlight()
          end
          hl.MatchParen.bold = true

          -- =========================
          -- 3. 语法高亮
          -- =========================
          hl.Comment = { fg = colors.dark_gray, italic = true }
          hl.String = { fg = colors.dark_black }

          -- Treesitter
          hl["@variable"] = black_fg()
          hl["@function"] = black_fg()
          hl["@keyword"] = { fg = colors.black, bold = true }
          hl["@string"] = { fg = colors.dark_black }
          hl["@type"] = black_fg()

          -- =========================
          -- 4. LSP / 诊断
          -- =========================
          -- 诊断文本颜色
          local diagnostic_groups = {
            "DiagnosticError",
            "DiagnosticWarn",
            "DiagnosticInfo",
            "DiagnosticHint",
          }

          for _, group in ipairs(diagnostic_groups) do
            hl[group] = black_fg()
            hl[group:gsub("Diagnostic", "DiagnosticVirtualText")] = { fg = colors.dark_gray }
            hl[group:gsub("Diagnostic", "DiagnosticUnderline")] = { undercurl = true }
          end

          -- =========================
          -- 5. 补全菜单 (nvim-cmp)
          -- =========================
          hl.CmpItemAbbr = black_fg()
          hl.CmpItemAbbrMatch = { fg = colors.brown, bold = true }
          hl.CmpItemAbbrMatchFuzzy = { fg = colors.brown }
          hl.CmpItemMenu = { fg = colors.gray }
          hl.PmenuSel = selection_highlight()

          -- =========================
          -- 6. Telescope
          -- =========================
          hl.TelescopeNormal = transparent_bg()
          hl.TelescopeBorder = transparent_bg()
          hl.TelescopeSelection = selection_highlight()
          hl.TelescopeMatching = { fg = colors.brown }

          -- =========================
          -- 7. Neo-tree
          -- =========================
          local neo_tree_groups = {
            "NeoTreeNormal",
            "NeoTreeNormalNC",
            "NeoTreeEndOfBuffer",
            "NeoTreeWinSeparator",
            "NeoTreeTitleBar",
          }

          for _, group in ipairs(neo_tree_groups) do
            hl[group] = transparent_bg()
          end

          hl.NeoTreeCursorLine = selection_highlight()
          hl.NeoTreeRootName = { bg = "NONE", fg = colors.black }
          hl.NeoTreeDirectoryName = black_fg()

          -- =========================
          -- 8. WhichKey / Lazy
          -- =========================
          hl.WhichKey = black_fg()
          hl.WhichKeyGroup = black_fg()
          hl.LazyNormal = transparent_bg()

          -- =========================
          -- 9. Diff / Git
          -- =========================
          hl.DiffAdd = transparent_bg()
          hl.DiffChange = transparent_bg()
          hl.DiffDelete = transparent_bg()
          hl.DiffText = { bg = colors.brown }

          -- =========================
          -- 10. 折叠
          -- =========================
          hl.Folded = { fg = colors.gray, bg = "NONE" }

          -- =========================
          -- 11. Buffer
          -- =========================
          local buffer_groups = {
            "BufferLineFill",
            "BufferLineBackground",
            "BufferLineBufferSelected",
            "BufferLineSeparator",
            "BufferLineIndicatorSelected",
          }

          for _, group in ipairs(buffer_groups) do
            hl[group] = transparent_bg()
          end

          -- =========================
          -- 12. 窗口/标签栏
          -- =========================
          -- 已包含在透明组中

          -- =========================
          -- 13. 导航相关
          -- =========================
          hl.NavicText = { bg = "NONE", fg = colors.black }
          hl.NavicSeparator = { bg = "NONE", fg = colors.black }

          -- treesitter-context
          hl.TreesitterContext = transparent_bg()
          hl.TreesitterContextLineNumber = transparent_bg()
          hl.TreesitterContextSeparator = transparent_bg()

          -- =========================
          -- 14. 其他细节
          -- =========================
          hl.NonText = { fg = colors.light_gray }
          hl.SpecialKey = { fg = colors.light_gray }
          hl.Directory = black_fg()
        end,
      }
    end,

    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },
}
