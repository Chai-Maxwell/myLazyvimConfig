-- ~/.config/nvim/lua/plugins/lualine.lua
return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local brown = "#DCB48C"
    local gold = "#A1551A"
    local green = "#125521"
    local red = "#D2442D"
    local blue = "#2B88B2"
    local fg = "#000000"

    opts.options.theme = {
      normal = {
        a = { bg = gold, fg = fg, bold = true },
        b = { bg = brown, fg = fg },
        c = { bg = brown, fg = fg },
      },
      insert = {
        a = { bg = green, fg = fg, bold = true },
        b = { bg = brown, fg = fg },
        c = { bg = brown, fg = fg },
      },
      visual = {
        a = { bg = blue, fg = fg, bold = true },
        b = { bg = brown, fg = fg },
        c = { bg = brown, fg = fg },
      },
      replace = {
        a = { bg = red, fg = fg, bold = true },
        b = { bg = brown, fg = fg },
        c = { bg = brown, fg = fg },
      },
      inactive = {
        a = { bg = "#444444", fg = fg },
        b = { bg = "#444444", fg = fg },
        c = { bg = "#444444", fg = fg },
      },
    }
  end,
}
