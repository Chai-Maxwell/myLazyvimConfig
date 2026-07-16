return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false, -- 已用 telescope 替代
    opts = {
      clipboard = {
        sync = "universal", -- 跨所有 Neovim 实例共享剪贴板（cut/copy/paste 文件操作）
      },
      default_component_configs = {
        icon = {
          provider = function(icon, node, _state)
            -- default behavior: use nvim-web-devicons for files
            if node.type == "file" or node.type == "terminal" then
              local success, web_devicons = pcall(require, "nvim-web-devicons")
              local name = node.type == "terminal" and "terminal" or node.name
              if success then
                local devicon, hl = web_devicons.get_icon(name)
                icon.text = devicon or icon.text
                icon.highlight = hl or icon.highlight
              end
            end
            -- override: src/ directory icon 改为绿色
            if node.type == "directory" and node.name == "src" then
              icon.highlight = "NeoTreeSrcDirectoryIcon"
            end
          end,
        },
      },
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
        },
        commands = {
          delete = function(state)
            local inputs = require("neo-tree.ui.inputs")
            local node = state.tree:get_node()
            if node:get_depth() == 1 then
              return
            end
            local path = node.path
            local msg = "Move " .. node.name .. " to trash?"
            inputs.confirm(msg, function(confirmed)
              if not confirmed then
                return
              end
              -- 移到系统回收站（macOS: Finder, Linux: Dolphin/kioclient）
              local trash_cmd = require("config.platform").trash_cmd(path)
              vim.fn.jobstart(trash_cmd, {
                detach = true,
                on_exit = function()
                  require("neo-tree.sources.manager").refresh(state.name)
                end,
              })
            end)
          end,
        },
      },
      source_selector = {
        winbar = true,
        separator = "┃", -- 加粗分隔符（filesystem / buffers / git_status 之间）
        separator_active = "┃",
        show_separator_on_edge = true,
      },
      event_handlers = {
        {
          event = "neo_tree_window_after_open",
          handler = function()
            -- neo-tree 左边栏边框加粗：设置 WinSeparator 为粗体高亮
            vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", {
              bold = true,
              fg = "#a1551a",
            })
            vim.wo.winhighlight = "WinSeparator:NeoTreeWinSeparator"
          end,
        },
        {
          event = "file_open_requested",
          handler = function(args)
            local filepath = args.path
            if filepath and filepath:match("%.pdf$") then
              -- 用系统默认应用打开 PDF（而非在 neovim 中打开）
              local platform = require("config.platform")
              vim.fn.jobstart(platform.open_file(filepath), { detach = true })
              -- 阻止 neovim 默认打开行为
              return { handled = true }
            end
          end,
        },
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
    end,
  },
}
