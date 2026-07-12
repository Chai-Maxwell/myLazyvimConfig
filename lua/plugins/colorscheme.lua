-- ~/.config/nvim/lua/plugins/colorscheme.lua
--
-- ╔══════════════════════════════════════════════════════════════╗
-- ║            ☀️  Warm Paper · 暖纸色 · Day Theme               ║
-- ║                                                              ║
-- ║  基调：奶油纸色底 + 焦糖棕 + 橄榄金，低对比、温润舒适        ║
-- ║  Base: warm cream paper + caramel brown + olive gold         ║
-- ╚══════════════════════════════════════════════════════════════╝

return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,

    opts = function()
      -- ╔══════════════════════════════════════════════════════════════╗
      -- ║  1. 调色板 · Palette                                        ║
      -- ╚══════════════════════════════════════════════════════════════╝
      local colors = {
        -- 前景/背景
        fg = "#111111",
        bg = "#fcf6e5",

        -- 暖色系 · Warm tones
        brown = "#DCB48C", -- 焦糖 / 状态栏底色
        gold = "#c96f4f", -- 橄榄金 / 行号 / 参数
        paleyellow = "#ffee99", -- 淡鹅黄 / 选区 / Normal 模式
        summerorange = "#ffa488", -- 夏日橘 / 成员字段 / Terminal 模式

        -- 冷色系 · Cool tones
        blue = "#195591", -- 深海蓝 / 函数名
        paleblue = "#9dd6d8", -- 淡青 / Visual 模式
        lightblue = "#DFFFFD", -- 极浅薄荷 / 暂未使用

        -- 绿色系 · Green tones
        darkgreen = "#288002", -- 深草绿 / 注释

        -- 中性色 · Neutral tones
        dark = "#222222", -- 深灰 / 字符串
        subtle = "#a0aaaa", -- 浅灰 / 分隔线 / inlay-hint

        -- 诊断语义色 · Diagnostic semantic colors
        red = "#f7768e", -- 柔玫红 / Error
        yellow = "#e0af68", -- 琥珀金 / Warning
        info = "#7aa2f7", -- 柔蓝 / Info
        hint = "#565f89", -- 灰紫 / Hint

        -- 插入/替换模式色（lualine 共享）
        plant_green = "#d6df89", -- 嫩绿 / Insert 模式
        replace_red = "#D2442D", -- 朱红 / Replace 模式
      }

      -- ╔══════════════════════════════════════════════════════════════╗
      -- ║  2. 工具函数 · Helpers                                      ║
      -- ╚══════════════════════════════════════════════════════════════╝
      local function bg_none()
        return { bg = "NONE" }
      end

      local function fg(c)
        return { fg = c }
      end

      local function fg_bold(c)
        return { fg = c, bold = true }
      end

      local function fg_italic(c)
        return { fg = c, italic = true }
      end

      local function select()
        return { fg = colors.dark, bg = colors.paleyellow }
      end

      local function subtle_fg(c)
        return { fg = c, bg = "NONE" }
      end

      return {
        style = "day",
        transparent = true,

        styles = {
          sidebars = "transparent",
          floats = "transparent",
        },

        on_highlights = function(hl, _)
          -- ╔════════════════════════════════════════════════════════╗
          -- ║  A. 编辑器核心 — 背景/边框/UI 基础                     ║
          -- ╚════════════════════════════════════════════════════════╝
          hl.Normal = bg_none()
          hl.NormalNC = bg_none()
          hl.NormalFloat = bg_none()
          hl.FloatBorder = bg_none()
          hl.FloatTitle = bg_none()
          hl.SignColumn = bg_none()
          hl.EndOfBuffer = bg_none()
          hl.FoldColumn = bg_none()
          hl.CursorColumn = bg_none()

          -- 光标行 / 行号
          hl.CursorLine = bg_none()
          hl.CursorLineNr = fg_bold(colors.brown)
          hl.LineNr = fg(colors.gold)

          -- 空白字符 / 特殊键 / 目录 / 折叠
          hl.NonText = fg(colors.paleyellow)
          hl.SpecialKey = fg(colors.paleyellow)
          hl.Directory = fg(colors.fg)
          hl.Folded = subtle_fg(colors.gold)

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  B. 选区 / 搜索（静态默认值；运行时由 ModeChanged 覆写）║
          -- ╚════════════════════════════════════════════════════════╝
          hl.Visual = select()
          hl.VisualNOS = select()
          hl.Search = select()
          hl.IncSearch = select()
          hl.CurSearch = select()
          hl.Substitute = select()
          hl.MatchParen = select()
          hl.MatchParen.bold = true

          -- vim-illuminate 光标下同词高亮
          hl.IlluminatedWordText = select()
          hl.IlluminatedWordRead = select()
          hl.IlluminatedWordWrite = select()

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  C. 状态栏 / 标签栏 / WinBar                           ║
          -- ╚════════════════════════════════════════════════════════╝
          hl.StatusLine = { bg = colors.brown }
          hl.StatusLineNC = { bg = colors.bg }
          hl.WinSeparator = bg_none()

          hl.TabLine = bg_none()
          hl.TabLineFill = bg_none()
          hl.TabLineSel = bg_none()

          hl.WinBar = bg_none()
          hl.WinBarNC = bg_none()

          hl.MsgArea = bg_none()
          hl.MsgSeparator = bg_none()

          -- 状态栏内诊断图标染色（lualine diagnostics 组件使用）
          hl.StatusLineDiagnosticError = { fg = colors.red, bg = colors.brown }
          hl.StatusLineDiagnosticWarn = { fg = colors.yellow, bg = colors.brown }
          hl.StatusLineDiagnosticInfo = { fg = colors.info, bg = colors.brown }
          hl.StatusLineDiagnosticHint = { fg = colors.hint, bg = colors.brown }

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  D. 弹出菜单 — Pmenu / WildMenu                        ║
          -- ╚════════════════════════════════════════════════════════╝
          hl.Pmenu = bg_none()
          hl.PmenuSel = select()
          hl.PmenuSbar = bg_none()
          hl.PmenuThumb = bg_none()

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  E. Treesitter 语法高亮                                 ║
          -- ╚════════════════════════════════════════════════════════╝
          -- 变量
          hl["@variable"] = fg(colors.fg)
          hl["@variable.parameter"] = fg(colors.gold)
          hl["@variable.member"] = fg(colors.summerorange)
          hl["@variable.builtin"] = fg(colors.brown)

          -- 函数 / 关键字 / 字符串 / 类型
          hl["@function"] = fg(colors.blue)
          hl["@function.call"] = fg(colors.blue)
          hl["@function.macro"] = fg(colors.gold)
          hl["@keyword"] = fg_bold(colors.fg)
          hl["@keyword.return"] = fg_bold(colors.gold)
          hl["@string"] = fg(colors.dark)
          hl["@string.regexp"] = fg(colors.gold)
          hl["@type"] = fg(colors.fg)
          hl["@type.builtin"] = fg_bold(colors.brown)

          -- 常量 / 数字 / 布尔
          hl["@constant"] = fg(colors.gold)
          hl["@constant.builtin"] = fg_bold(colors.gold)
          hl["@constant.macro"] = fg(colors.gold)
          hl["@number"] = fg(colors.gold)
          hl["@boolean"] = fg_bold(colors.gold)

          -- 属性 / 字段
          hl["@property"] = fg(colors.summerorange)
          hl["@field"] = fg(colors.summerorange)

          -- 运算符 / 标点
          hl["@operator"] = fg(colors.fg)
          hl["@punctuation"] = fg(colors.subtle)
          hl["@punctuation.bracket"] = fg(colors.fg)
          hl["@punctuation.delimiter"] = fg(colors.subtle)
          hl["@punctuation.special"] = fg(colors.gold)

          -- 标签（HTML/JSX/Vue）
          hl["@tag"] = fg(colors.blue)
          hl["@tag.delimiter"] = fg(colors.subtle)
          hl["@tag.attribute"] = fg(colors.gold)

          -- 命名空间 / 模块
          hl["@namespace"] = fg(colors.blue)
          hl["@module"] = fg(colors.blue)

          -- Markdown
          hl["@markup.heading"] = fg_bold(colors.brown)
          for i = 1, 6 do
            hl["@markup.heading." .. i .. ".markdown"] = bg_none()
          end
          hl["@markup.raw"] = fg(colors.brown)
          hl["@markup.raw.markdown_inline"] = subtle_fg(colors.brown)
          hl["@markup.link"] = fg(colors.blue)
          hl["@markup.link.url"] = fg(colors.subtle)
          hl["@markup.list"] = fg(colors.gold)
          hl["@markup.strong"] = { bold = true }
          hl["@markup.italic"] = { italic = true }
          hl["@markup.strikethrough"] = { strikethrough = true }

          -- 传统正则高亮（非 treesitter 降级）
          hl.Comment = fg_italic(colors.darkgreen)
          hl.String = fg(colors.dark)

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  F. LSP 语义 Token（@lsp.type.*）                      ║
          -- ╚════════════════════════════════════════════════════════╝
          hl["@lsp.type.variable"] = hl["@variable"]
          hl["@lsp.type.parameter"] = hl["@variable.parameter"]
          hl["@lsp.type.member"] = hl["@variable.member"]
          hl["@lsp.type.function"] = hl["@function"]
          hl["@lsp.type.method"] = hl["@function"]
          hl["@lsp.type.macro"] = hl["@function.macro"]
          hl["@lsp.type.type"] = hl["@type"]
          hl["@lsp.type.class"] = fg_bold(colors.fg)
          hl["@lsp.type.enum"] = hl["@type"]
          hl["@lsp.type.interface"] = fg_bold(colors.blue)
          hl["@lsp.type.struct"] = hl["@type"]
          hl["@lsp.type.keyword"] = hl["@keyword"]
          hl["@lsp.type.modifier"] = fg(colors.gold)
          hl["@lsp.type.comment"] = hl.Comment
          hl["@lsp.type.string"] = hl["@string"]
          hl["@lsp.type.number"] = hl["@number"]
          hl["@lsp.type.boolean"] = hl["@boolean"]
          hl["@lsp.type.operator"] = hl["@operator"]
          hl["@lsp.type.property"] = hl["@property"]
          hl["@lsp.type.enumMember"] = fg(colors.summerorange)
          hl["@lsp.type.event"] = fg(colors.paleblue)
          hl["@lsp.type.typeParameter"] = fg(colors.gold)
          hl["@lsp.type.namespace"] = hl["@namespace"]
          hl["@lsp.type.decorator"] = fg(colors.gold)

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  G. LSP / 诊断 · Diagnostics                           ║
          -- ╚════════════════════════════════════════════════════════╝
          local diags = {
            Error = colors.red,
            Warn = colors.yellow,
            Info = colors.info,
            Hint = colors.hint,
          }

          for type, col in pairs(diags) do
            hl["Diagnostic" .. type] = fg(colors.fg)
            hl["DiagnosticVirtualText" .. type] = { fg = col }
            hl["DiagnosticUnderline" .. type] = { undercurl = true, sp = col }
          end

          hl.DiagnosticOk = fg(colors.darkgreen)

          hl.LspInlayHint = {
            fg = colors.subtle,
            bg = colors.darkgreen,
            italic = true,
          }

          -- LSP 引用高亮
          hl.LspReferenceText = { bg = colors.subtle }
          hl.LspReferenceRead = { bg = colors.subtle }
          hl.LspReferenceWrite = { bg = colors.subtle }

          -- LSP 签名帮助
          hl.LspSignatureActiveParameter = { bold = true }

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  H. 补全 — blink.cmp（兼容 CmpItem 命名）              ║
          -- ╚════════════════════════════════════════════════════════╝
          hl.CmpItemAbbr = fg(colors.fg)
          hl.CmpItemAbbrMatch = fg_bold(colors.brown)
          hl.CmpItemAbbrMatchFuzzy = fg(colors.brown)
          hl.CmpItemMenu = fg(colors.gold)
          hl.CmpItemKind = fg(colors.gold)
          hl.CmpItemKindDefault = fg(colors.fg)

          -- Kind-specific 补全类型图标颜色
          hl.CmpItemKindVariable = fg(colors.fg)
          hl.CmpItemKindFunction = fg(colors.blue)
          hl.CmpItemKindMethod = fg(colors.blue)
          hl.CmpItemKindKeyword = fg_bold(colors.fg)
          hl.CmpItemKindClass = fg_bold(colors.fg)
          hl.CmpItemKindInterface = fg_bold(colors.blue)
          hl.CmpItemKindStruct = fg(colors.fg)
          hl.CmpItemKindEnum = fg(colors.gold)
          hl.CmpItemKindConstant = fg(colors.gold)
          hl.CmpItemKindProperty = fg(colors.summerorange)
          hl.CmpItemKindField = fg(colors.summerorange)
          hl.CmpItemKindTypeParameter = fg(colors.gold)
          hl.CmpItemKindModule = fg(colors.blue)
          hl.CmpItemKindSnippet = fg(colors.dark)
          hl.CmpItemKindColor = fg(colors.red)
          hl.CmpItemKindFile = fg(colors.fg)
          hl.CmpItemKindFolder = fg(colors.paleyellow)
          hl.CmpItemKindUnit = fg(colors.gold)
          hl.CmpItemKindValue = fg(colors.fg)
          hl.CmpItemKindEnumMember = fg(colors.summerorange)
          hl.CmpItemKindOperator = fg(colors.fg)
          hl.CmpItemKindReference = fg(colors.fg)
          hl.CmpItemKindText = fg(colors.fg)
          hl.CmpItemKindEvent = fg(colors.paleblue)

          -- blink.cmp 自有 highlight 组
          hl.BlinkCmpMenu = bg_none()
          hl.BlinkCmpMenuBorder = bg_none()
          hl.BlinkCmpMenuSelection = select()
          hl.BlinkCmpLabel = fg(colors.fg)
          hl.BlinkCmpLabelMatch = fg_bold(colors.brown)
          hl.BlinkCmpLabelDescription = fg(colors.subtle)
          hl.BlinkCmpLabelDetail = fg(colors.gold)
          hl.BlinkCmpKind = fg(colors.gold)
          hl.BlinkCmpSource = fg(colors.subtle)
          hl.BlinkCmpGhostText = fg(colors.subtle)
          hl.BlinkCmpDoc = bg_none()
          hl.BlinkCmpDocBorder = bg_none()
          hl.BlinkCmpSignatureHelp = bg_none()
          hl.BlinkCmpSignatureHelpBorder = bg_none()

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  I. Telescope 模糊查找                                 ║
          -- ╚════════════════════════════════════════════════════════╝
          hl.TelescopeNormal = bg_none()
          hl.TelescopeBorder = bg_none()
          hl.TelescopePromptNormal = bg_none()
          hl.TelescopeResultsNormal = bg_none()
          hl.TelescopePreviewNormal = bg_none()
          hl.TelescopeSelection = select()
          hl.TelescopeMatching = fg(colors.brown)
          hl.TelescopePromptPrefix = fg(colors.gold)
          hl.TelescopePromptCounter = fg(colors.subtle)

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  J. Neo-tree 文件树                                    ║
          -- ╚════════════════════════════════════════════════════════╝
          hl.NeoTreeNormal = bg_none()
          hl.NeoTreeNormalNC = bg_none()
          hl.NeoTreeEndOfBuffer = bg_none()
          hl.NeoTreeWinSeparator = bg_none()
          hl.NeoTreeCursorLine = select()
          hl.NeoTreeRootName = fg(colors.yellow)
          hl.NeoTreeDirectoryIcon = fg(colors.yellow)
          hl.NeoTreeSrcDirectoryIcon = fg(colors.darkgreen)
          hl.NeoTreePrompt = bg_none()
          hl.NeoTreeTabActive = fg_bold(colors.gold)
          hl.NeoTreeTabInactive = fg(colors.subtle)
          hl.NeoTreeTabSeparatorActive = fg(colors.subtle)
          hl.NeoTreeTitleBar = fg_bold(colors.gold)
          hl.NeoTreeFloatTitle = fg_bold(colors.gold)
          hl.NeoTreeFileNameOpened = fg(colors.brown)

          -- Git 状态 — 图标 + 文件名染色
          hl.NeoTreeGitAdded = fg(colors.paleyellow)
          hl.NeoTreeGitModified = fg(colors.yellow)
          hl.NeoTreeGitDeleted = fg(colors.red)
          hl.NeoTreeGitConflict = fg(colors.red)
          hl.NeoTreeGitUntracked = fg(colors.info)
          hl.NeoTreeGitRenamed = fg(colors.yellow)
          hl.NeoTreeGitStaged = fg(colors.paleyellow)
          hl.NeoTreeGitUnstaged = fg(colors.brown)
          hl.NeoTreeGitIgnored = fg(colors.subtle)
          hl.NeoTreeModified = fg(colors.yellow)

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  K. BufferLine 缓冲区标签                              ║
          -- ╚════════════════════════════════════════════════════════╝
          hl.BufferLineFill = bg_none()
          hl.BufferLineBackground = bg_none()
          hl.BufferLineBufferSelected = bg_none()
          hl.BufferLineSeparator = bg_none()
          hl.BufferLineIndicatorSelected = bg_none()
          hl.BufferLineTabSelected = fg_bold(colors.brown)
          hl.BufferLineCloseButton = fg(colors.red)
          hl.BufferLineCloseButtonSelected = fg(colors.red)
          hl.BufferLineModified = fg(colors.yellow)
          hl.BufferLineModifiedSelected = fg(colors.yellow)
          hl.BufferLineDiagnostic = fg(colors.info)
          hl.BufferLineDuplicate = fg(colors.subtle)
          hl.BufferLinePick = fg_bold(colors.gold)

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  L. nvim-notify + noice.nvim 通知系统                  ║
          -- ╚════════════════════════════════════════════════════════╝
          -- 通知背景使用暖纸色，与整体主题融为一体
          hl.NotifyBackground = { bg = colors.bg, fg = colors.fg }
          hl.NotifyERRORBody = { bg = colors.bg, fg = colors.fg }
          hl.NotifyWARNBody = { bg = colors.bg, fg = colors.fg }
          hl.NotifyINFOBody = { bg = colors.bg, fg = colors.fg }
          hl.NotifyDEBUGBody = { bg = colors.bg, fg = colors.fg }

          -- 通知边框 / 图标 / 标题 用诊断语义色区分等级
          hl.NotifyERRORBorder = fg(colors.red)
          hl.NotifyWARNBorder = fg(colors.yellow)
          hl.NotifyINFOBorder = fg(colors.info)
          hl.NotifyDEBUGBorder = fg(colors.hint)

          hl.NotifyERRORIcon = fg(colors.red)
          hl.NotifyWARNIcon = fg(colors.yellow)
          hl.NotifyINFOIcon = fg(colors.info)
          hl.NotifyDEBUGIcon = fg(colors.hint)

          hl.NotifyERRORTitle = fg_bold(colors.red)
          hl.NotifyWARNTitle = fg_bold(colors.yellow)
          hl.NotifyINFOTitle = fg_bold(colors.info)
          hl.NotifyDEBUGTitle = fg_bold(colors.hint)

          -- Noice 弹出窗口
          hl.NoicePopup = bg_none()
          hl.NoicePopupBorder = bg_none()
          hl.NoiceCmdlinePopup = bg_none()
          hl.NoiceCmdlinePopupBorder = fg(colors.gold)
          hl.NoiceConfirmBorder = fg(colors.yellow)

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  M. Treesitter Context 上下文悬浮                      ║
          -- ╚════════════════════════════════════════════════════════╝
          hl.TreesitterContext = bg_none()
          hl.TreesitterContextLineNumber = bg_none()
          hl.TreesitterContextSeparator = bg_none()

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  N. Navic 面包屑导航（winbar 内嵌）                    ║
          -- ╚════════════════════════════════════════════════════════╝
          hl.NavicText = fg(colors.fg)
          hl.NavicSeparator = fg(colors.subtle)

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  O. Diff / Gitsigns 差异标记                           ║
          -- ╚════════════════════════════════════════════════════════╝
          hl.DiffAdd = bg_none()
          hl.DiffChange = bg_none()
          hl.DiffDelete = bg_none()
          hl.DiffText = { bg = colors.brown }

          hl.GitSignsAdd = fg(colors.paleyellow)
          hl.GitSignsChange = fg(colors.yellow)
          hl.GitSignsDelete = fg(colors.red)

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  P. WhichKey 快捷键提示                                ║
          -- ╚════════════════════════════════════════════════════════╝
          hl.WhichKey = fg(colors.gold)
          hl.WhichKeyGroup = fg(colors.paleblue)
          hl.WhichKeySeparator = fg(colors.subtle)
          hl.WhichKeyDesc = fg(colors.fg)
          hl.WhichKeyFloat = bg_none()
          hl.WhichKeyBorder = bg_none()
          hl.WhichKeyValue = fg(colors.brown)

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  Q. Indent Blankline 缩进引导线                        ║
          -- ╚════════════════════════════════════════════════════════╝
          hl.IblIndent = fg(colors.subtle)
          hl.IblScope = fg(colors.brown)

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  R. Lazy.nvim 插件管理界面                             ║
          -- ╚════════════════════════════════════════════════════════╝
          hl.LazyNormal = bg_none()
          hl.LazyBorder = fg("#000000")
          hl.LazyButton = { fg = colors.fg, bg = colors.brown }
          hl.LazyButtonActive = select()
          hl.LazyReasonPlugin = fg(colors.paleblue)
          hl.LazyProgressDone = fg(colors.paleyellow)
          hl.LazyProgressTodo = fg(colors.subtle)

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  S. Mason LSP/工具安装器界面                            ║
          -- ╚════════════════════════════════════════════════════════╝
          hl.MasonNormal = bg_none()
          hl.MasonHeader = fg_bold(colors.gold)
          hl.MasonHighlight = fg(colors.brown)
          hl.MasonHighlightBlock = { bg = colors.brown }
          hl.MasonMuted = fg(colors.subtle)

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  T. Trouble 诊断列表                                   ║
          -- ╚════════════════════════════════════════════════════════╝
          hl.TroubleNormal = bg_none()
          hl.TroubleCount = fg(colors.brown)
          hl.TroubleLocation = fg(colors.subtle)
          hl.TroubleFoldIcon = fg(colors.paleyellow)

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  U. Claude Code AI 对话侧边栏                          ║
          -- ╚════════════════════════════════════════════════════════╝
          hl.ClaudeBorder = bg_none()
          hl.ClaudeInput = { fg = colors.fg, bg = colors.dark }
          hl.ClaudeUserMessage = { fg = colors.fg, bg = colors.brown }
          hl.ClaudeThinking = { fg = colors.paleyellow, italic = true }

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  V. Mini 系列插件                                      ║
          -- ╚════════════════════════════════════════════════════════╝
          hl.MiniIndentscopeSymbol = fg(colors.brown)
          hl.MiniFilesTitle = fg_bold(colors.gold)
          hl.MiniFilesTitleFocused = fg_bold(colors.brown)
          hl.MiniCursorword = { bg = colors.subtle }
          hl.MiniCursorwordCurrent = { bg = colors.subtle }
          hl.MiniTrailspace = { bg = colors.red }

          -- mini.hipatterns
          hl.MiniHipatternsFixme = fg_bold(colors.red)
          hl.MiniHipatternsHack = fg_bold(colors.yellow)
          hl.MiniHipatternsTodo = fg_bold(colors.blue)
          hl.MiniHipatternsNote = fg_bold(colors.info)

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  W. Snacks.nvim 工具集                                 ║
          -- ╚════════════════════════════════════════════════════════╝
          hl.SnacksNormal = bg_none()
          hl.SnacksBorder = bg_none()
          hl.SnacksInput = bg_none()
          hl.SnacksTitle = fg_bold(colors.gold)
          hl.SnacksPickerDir = fg(colors.yellow)
          hl.SnacksPickerFile = fg(colors.fg)
          hl.SnacksPickerGit = fg(colors.info)
          hl.SnacksIndent = fg(colors.subtle)
          hl.SnacksIndentScope = fg(colors.brown)
          hl.SnacksDashboardNormal = bg_none()
          hl.SnacksDashboardKey = fg(colors.gold)
          hl.SnacksDashboardDesc = fg(colors.fg)
          hl.SnacksDashboardDir = fg(colors.blue)
          hl.SnacksDashboardFile = fg(colors.fg)
          hl.SnacksDashboardTitle = fg_bold(colors.brown)
          hl.SnacksDashboardFooter = fg(colors.subtle)
          hl.SnacksDashboardHeader = fg_bold(colors.brown)
          hl.SnacksNotifierInfo = { bg = colors.bg, fg = colors.fg }
          hl.SnacksNotifierWarn = { bg = colors.bg, fg = colors.fg }
          hl.SnacksNotifierError = { bg = colors.bg, fg = colors.fg }
          hl.SnacksNotifierDebug = { bg = colors.bg, fg = colors.fg }
          hl.SnacksNotifierHistoryTitle = fg_bold(colors.gold)
          hl.SnacksNotifierHistoryItem = fg(colors.fg)

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  X. Render-Markdown 预览增强                           ║
          -- ╚════════════════════════════════════════════════════════╝
          hl.RenderMarkdownH1 = fg_bold(colors.brown)
          hl.RenderMarkdownH2 = fg_bold(colors.gold)
          hl.RenderMarkdownH3 = fg_bold(colors.blue)
          hl.RenderMarkdownH4 = fg_bold(colors.fg)
          hl.RenderMarkdownH5 = fg(colors.subtle)
          hl.RenderMarkdownH6 = fg(colors.subtle)
          hl.RenderMarkdownBullet = fg(colors.gold)
          hl.RenderMarkdownCode = fg(colors.brown)
          hl.RenderMarkdownCodeInline = { fg = colors.brown, bg = "NONE" }
          hl.RenderMarkdownTableHead = fg_bold(colors.gold)
          hl.RenderMarkdownTableRow = fg(colors.fg)
          hl.RenderMarkdownDash = fg(colors.subtle)

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  Y. Todo-Comments 注释高亮                             ║
          -- ╚════════════════════════════════════════════════════════╝
          hl.TodoFgFIX = fg(colors.red)
          hl.TodoBgFIX = bg_none()
          hl.TodoFgTODO = fg(colors.blue)
          hl.TodoBgTODO = bg_none()
          hl.TodoFgHACK = fg(colors.yellow)
          hl.TodoBgHACK = bg_none()
          hl.TodoFgWARN = fg(colors.yellow)
          hl.TodoBgWARN = bg_none()
          hl.TodoFgPERF = fg(colors.paleyellow)
          hl.TodoBgPERF = bg_none()
          hl.TodoFgNOTE = fg(colors.info)
          hl.TodoBgNOTE = bg_none()
          hl.TodoFgTEST = fg(colors.paleblue)
          hl.TodoBgTEST = bg_none()

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  Z. Flash.nvim 跳转导航                                ║
          -- ╚════════════════════════════════════════════════════════╝
          hl.FlashLabel = { fg = colors.dark, bg = colors.paleyellow, bold = true }
          hl.FlashBackdrop = fg(colors.subtle)
          hl.FlashMatch = { bg = colors.brown }
          hl.FlashCurrent = { bg = colors.paleyellow }

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  AA. Dressing.nvim 输入框美化                          ║
          -- ╚════════════════════════════════════════════════════════╝
          hl.DressingNormal = bg_none()
          hl.DressingBorder = bg_none()
          hl.DressingInput = { fg = colors.fg, bg = colors.dark }

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  AB. Diffview.nvim 差异查看                            ║
          -- ╚════════════════════════════════════════════════════════╝
          hl.DiffviewNormal = bg_none()
          hl.DiffviewFilePanelTitle = fg_bold(colors.gold)

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  AC. Neogit Git UI                                     ║
          -- ╚════════════════════════════════════════════════════════╝
          hl.NeogitNormal = bg_none()
          hl.NeogitBorder = bg_none()
          hl.NeogitSectionHeader = fg_bold(colors.gold)
          hl.NeogitDiffAdd = fg(colors.paleyellow)
          hl.NeogitDiffDelete = fg(colors.red)

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  AD. Grug-Far 搜索替换                                 ║
          -- ╚════════════════════════════════════════════════════════╝
          hl.GrugFarNormal = bg_none()
          hl.GrugFarBorder = bg_none()

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  AE. Edgy.nvim 窗口布局                                ║
          -- ╚════════════════════════════════════════════════════════╝
          hl.EdgyNormal = bg_none()
          hl.EdgyTitle = fg_bold(colors.gold)

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  AF. DAP 调试器                                        ║
          -- ╚════════════════════════════════════════════════════════╝
          hl.DapBreakpoint = fg(colors.red)
          hl.DapBreakpointCondition = fg(colors.yellow)
          hl.DapBreakpointRejected = fg(colors.subtle)
          hl.DapLogPoint = fg(colors.info)
          hl.DapStopped = fg(colors.paleyellow)
          hl.DapUIVariable = fg(colors.fg)
          hl.DapUIValue = fg(colors.gold)

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  AG. Dashboard / Alpha 启动页                          ║
          -- ╚════════════════════════════════════════════════════════╝
          hl.AlphaHeader = fg_bold(colors.brown)
          hl.AlphaButtons = fg(colors.fg)
          hl.AlphaShortcut = fg(colors.gold)
          hl.AlphaFooter = fg(colors.subtle)

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  AH. 终端 / 内嵌终端                                   ║
          -- ╚════════════════════════════════════════════════════════╝
          hl.Terminal = bg_none()

          -- ╔════════════════════════════════════════════════════════╗
          -- ║  AI. 杂项 · Miscellaneous                              ║
          -- ╚════════════════════════════════════════════════════════╝
          hl.ColorColumn = bg_none()
          hl.Conceal = fg(colors.subtle)
          hl.Title = fg_bold(colors.brown)
          hl.Question = fg(colors.paleblue)
          hl.QuickFixLine = select()
          hl.MoreMsg = fg(colors.info)
          hl.WarningMsg = fg(colors.yellow)
          hl.ErrorMsg = fg(colors.red)
          hl.ModeMsg = fg_bold(colors.fg)
          hl.SpellBad = { undercurl = true, sp = colors.red }
          hl.SpellCap = { undercurl = true, sp = colors.yellow }
          hl.SpellRare = { undercurl = true, sp = colors.info }
          hl.SpellLocal = { undercurl = true, sp = colors.hint }
        end,
      }
    end,

    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")

      -- ╔══════════════════════════════════════════════════════════════╗
      -- ║  模式色 → selection 高亮动态切换（与 lualine 模式色一致）    ║
      -- ╚══════════════════════════════════════════════════════════════╝
      local mode_sel = {
        n = "#ffee99", -- normal:     pale_yellow  · 鹅黄
        no = "#ffee99", -- op-pending: pale_yellow
        i = "#d6df89", -- insert:     plant_green  · 嫩绿
        ic = "#d6df89", -- insert-completion
        ix = "#d6df89", -- insert x-mode
        v = "#9dd6d8", -- visual:     pale_blue    · 淡青
        V = "#9dd6d8", -- visual-line
        ["\22"] = "#9dd6d8", -- visual-block (Ctrl-V)
        s = "#9dd6d8", -- select
        S = "#9dd6d8", -- select-line
        R = "#D2442D", -- replace:    red          · 朱红
        Rc = "#D2442D", -- replace-completion
        Rv = "#D2442D", -- virtual-replace
        t = "#ffa488", -- terminal:   summer_orange · 夏日橘
        c = "#ffee99", -- command:    pale_yellow
      }

      local function update_sel_highlights()
        local mode = vim.fn.mode()
        local bg = mode_sel[mode] or "#288002"
        local fg = "#222222"

        -- 文本选区 / 搜索匹配
        vim.api.nvim_set_hl(0, "Visual", { bg = bg, fg = fg })
        vim.api.nvim_set_hl(0, "VisualNOS", { bg = bg, fg = fg })
        vim.api.nvim_set_hl(0, "Search", { bg = bg, fg = fg })
        vim.api.nvim_set_hl(0, "IncSearch", { bg = bg, fg = fg })
        vim.api.nvim_set_hl(0, "CurSearch", { bg = bg, fg = fg })
        vim.api.nvim_set_hl(0, "Substitute", { bg = bg, fg = fg })
        vim.api.nvim_set_hl(0, "MatchParen", { bg = bg, fg = fg, bold = true })

        -- 光标下相同词高亮
        vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = bg, fg = fg })
        vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = bg, fg = fg })
        vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = bg, fg = fg })

        -- UI 选中项（与文本选区保持一致）
        vim.api.nvim_set_hl(0, "NeoTreeCursorLine", { bg = bg, fg = fg })
        vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = bg, fg = fg })
        vim.api.nvim_set_hl(0, "PmenuSel", { bg = bg, fg = fg })
        vim.api.nvim_set_hl(0, "LazyButtonActive", { bg = bg, fg = fg })
      end

      vim.api.nvim_create_autocmd("ModeChanged", {
        pattern = "*",
        callback = update_sel_highlights,
      })

      -- 启动时延迟应用，覆盖 on_highlights 的默认值
      vim.schedule(update_sel_highlights)
    end,
  },
}
