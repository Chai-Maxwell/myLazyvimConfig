return {
  {
    "nvim-neo-tree/neo-tree.nvim",
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
              -- macOS: use osascript to move file/folder to trash
              local trash_cmd = { "osascript", "-e", string.format(
                'tell app "Finder" to delete POSIX file %q',
                path
              ) }
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
      event_handlers = {
        {
          event = "file_open_requested",
          handler = function(args)
            local filepath = args.path
            if filepath and filepath:match("%.pdf$") then
              -- 用 macOS 的 open 命令调用预览打开 PDF
              vim.fn.jobstart({ "open", filepath }, { detach = true })
              -- 阻止 neovim 默认打开行为
              return { handled = true }
            end
          end,
        },
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
      vim.api.nvim_create_user_command("OpenInFinder", function()
        -- 优先获取 neo-tree 浏览的根目录，否则用当前工作目录
        local path = vim.fn.getcwd()
        local ok, manager = pcall(require, "neo-tree.sources.manager")
        if ok then
          local state = manager.get_state("filesystem")
          if state and state.path then
            path = state.path
          end
        end
        vim.fn.jobstart({ "open", path }, { detach = true })
      end, { desc = "在访达中打开当前工作目录" })
    end,
  },
}
