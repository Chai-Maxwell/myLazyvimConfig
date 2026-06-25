return {
  "folke/which-key.nvim",
  opts = function(_, opts)
    opts.win = opts.win or {}

    --opts.win.anchor = "NE"

    -- 必须是 number
    opts.win.row = 0
    opts.win.col = vim.o.columns

    opts.win.border = "rounded"
    opts.win.padding = { 0, 0, 0, 0 }

    opts.win.width = 35

    return opts
  end,
}
