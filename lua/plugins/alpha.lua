return {
  {
    "goolord/alpha-nvim",
    name = "minimal-alpha",
    lazy = false,
    priority = 1000,
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- ========= ASCII HEADER（WHITE SPACE）=========
      dashboard.section.header.val = {
        " ",
        "██╗    ██╗██╗  ██╗██╗████████╗███████╗    ███████╗██████╗  █████╗  ██████╗███████╗",
        "██║    ██║██║  ██║██║╚══██╔══╝██╔════╝    ██╔════╝██╔══██╗██╔══██╗██╔════╝██╔════╝",
        "██║ █╗ ██║███████║██║   ██║   █████╗      ███████╗██████╔╝███████║██║     █████╗  ",
        "██║███╗██║██╔══██║██║   ██║   ██╔══╝      ╚════██║██╔═══╝ ██╔══██║██║     ██╔══╝  ",
        "╚███╔███╔╝██║  ██║██║   ██║   ███████╗    ███████║██║     ██║  ██║╚██████╗███████╗",
        " ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝   ╚═╝   ╚══════╝    ╚══════╝╚═╝     ╚═╝  ╚═╝ ╚═════╝╚══════╝",
        " ",
        "Welcome to the White Space. You've been living here for as long as you can remember.",
      }

      dashboard.section.header.opts = {
        position = "center",
      }

      -- ========= BUTTONS =========
      local button = dashboard.button
      dashboard.section.buttons.val = {
        button("e", "  New file", "<cmd>ene<CR>"),
        button("f", "  Find file", "<cmd>Telescope find_files<CR>"),
        button("r", "  Recent files", "<cmd>Telescope oldfiles<CR>"),

        button("c", " " .. " Config", "<cmd>Telescope find_files cwd=~/.config/nvim<CR>"),

        button("q", "  Quit", "<cmd>qa<CR>"),
      }

      -- ========= 布局（视觉居中）=========
      dashboard.config.layout = {
        { type = "padding", val = 6 },
        dashboard.section.header,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
      }

      -- ========= 透明 UI =========
      vim.cmd([[
        hi AlphaNormal guibg=NONE ctermbg=NONE
        hi AlphaHeader guibg=NONE
        hi AlphaButtons guibg=NONE
        hi AlphaShortcut guibg=NONE
      ]])

      -- ========= 去 UI 干扰 =========
      vim.opt.laststatus = 0
      vim.opt.showtabline = 0

      vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaReady",
        callback = function()
          vim.opt_local.winbar = ""
        end,
      })

      -- ========= 启动 =========
      alpha.setup(dashboard.opts)

      vim.cmd([[autocmd VimEnter * Alpha]])
    end,
  },
}
