return {
  "tpope/vim-fugitive",
  cmd = { "Git", "G", "Gedit", "Gdiffsplit", "Gvdiffsplit", "Gread", "Gwrite", "Gbrowse" },
  keys = {
    { "<leader>gs", "<cmd>Git<CR>", desc = "Fugitive 状态窗口" },
    { "<leader>gb", "<cmd>Git blame<CR>", desc = "Fugitive Blame" },
    { "<leader>gl", "<cmd>Git log<CR>", desc = "Fugitive 日志" },
  },

  {

    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(m, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(m, l, r, opts)
        end
        map("n", "]c", gs.next_hunk, { desc = "下一改动块" })
        map("n", "[c", gs.prev_hunk, { desc = "上一改动块" })
        map("n", "<leader>hs", gs.stage_hunk, { desc = "暂存块" })
        map("n", "<leader>hr", gs.reset_hunk, { desc = "撤销块" })
        map("n", "<leader>hp", gs.preview_hunk, { desc = "预览改动" })
        map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "行尾 blame" })
      end,
    },
  },

  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    cmd = "Neogit",
    keys = { { "<leader>gg", "<cmd>Neogit<CR>", desc = "Neogit" } },
  },
}
