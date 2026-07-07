-- ~/.config/nvim/lua/plugins/orgmode.lua
-- Orgmode support for Neovim
return {
  {
    "nvim-orgmode/orgmode",
    ft = "org", -- org 文件打开时立即加载，确保 ftplugin（iabbrev、buffer mappings）正常生效
    config = function()
      require("orgmode").setup({
        org_agenda_files = { "~/org/**/*.org", "~/stuff/MyNote/*.org" },
        org_default_notes_file = "~/org/notes.org",
        org_capture_templates = {
          t = {
            description = "Task",
            template = "* TODO %?\n  %u",
          },
          n = {
            description = "Note",
            template = "* %?\n  %u",
          },
          m = {
            description = "Meeting",
            template = "* MEETING %?\n  %U\n  %a",
          },
        },
        org_todo_keywords = { "TODO(t)", "NEXT(n)", "WAIT(w)", "|", "DONE(d)", "CANCELLED(c)" },
        org_priority_default = "B",
        org_priority_highest = "A",
        org_priority_lowest = "C",
        org_todo_keyword_faces = {
          TODO = ":foreground #D2442D :weight bold",
          NEXT = ":foreground #195591 :weight bold",
          WAIT = ":foreground #a1551a :weight bold",
          DONE = ":foreground #288002 :weight bold",
          CANCELLED = ":foreground #a0aaaa :weight bold",
        },
        org_hide_leading_stars = true,
        org_hide_emphasis_markers = true,
        org_startup_indented = true,
        org_startup_folded = "overview",
        org_ellipsis = "…",
        org_highlight_latex_and_related = "entities",
        org_log_done = "time",
        org_adapt_indentation = true,
        win_split_mode = "float",

        -- Agenda 排序策略
        org_agenda_sorting_strategy = {
          agenda = { "time-up", "priority-down", "category-keep" }, -- 时间优先，同时间按优先级
          todo = { "todo-state-up", "priority-down", "category-keep" }, -- 按工作流状态分组
          tags = { "tag-up", "priority-down", "category-keep" }, -- 按 tag 字母序分组
        },

        -- 预设 Agenda 视图（在 agenda prompt 中直接按键进入）
        org_agenda_custom_commands = {
          w = {
            description = "Weekly Angenda & TODO",
            types = {
              { type = "agenda", org_agenda_span = "week" },
              { type = "tags_todo", match = '+PRIORITY="A"' },
            },
          },
          d = {
            description = "今日待办（agenda + 所有 TODO）",
            types = {
              { type = "agenda", org_agenda_span = "day" },
              { type = "todo" },
            },
          },
          p = {
            description = "Sorted by Tags",
            types = {
              { type = "tags_todo", match = "orgmode" },
            },
          },
        },

        mappings = {
          prefix = "<Leader>o",
          global = {
            org_agenda = { "<prefix>a", desc = "󰲠 Org Agenda" },
            org_capture = { "<prefix>c", desc = "󰲠 Org Capture" },
          },
        },
      })
    end,
  },
}
