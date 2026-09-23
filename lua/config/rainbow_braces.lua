-- lua/config/rainbow_braces.lua
-- rainbow braces：.tex 同级花括号同色，区分嵌套层级
-- 基于 latex 树解析器，转义 \{\} 与注释内括号由语法结构天然排除（不是 { } token）
local M = {}

-- 循环方向：最外层 = RainbowBrace4（橄榄金），每深入一层索引 -1，4 级循环
local HL = {
  "RainbowBrace1",
  "RainbowBrace2",
  "RainbowBrace3",
  "RainbowBrace4",
}
local ns = vim.api.nvim_create_namespace("latex_rainbow_braces")

local function apply(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "latex")
  if not ok then
    return
  end
  local tree = parser:parse()[1]

  local depth = 0
  local function walk(node)
    local t = node:type()
    if t == "{" or t == "}" then
      local row, col = node:start() -- 0-indexed row, 0-indexed byte col
      local grp
      if t == "{" then
        grp = HL[#HL - (depth % #HL)]
        depth = depth + 1
      else
        depth = depth - 1
        if depth < 0 then
          return -- 语法错误导致的多余 `}` 跳过
        end
        grp = HL[#HL - (depth % #HL)]
      end
      vim.api.nvim_buf_set_extmark(bufnr, ns, row, col, {
        end_col = col + 1,
        hl_group = grp,
        priority = 200,
      })
      return
    end
    for child in node:iter_children() do
      walk(child)
    end
  end
  walk(tree:root())
end

function M.attach(bufnr)
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "latex")
  if not ok then
    return
  end
  local pending = false
  parser:register_cbs({
    on_changedtree = function()
      if pending then
        return
      end
      pending = true
      vim.defer_fn(function()
        pending = false
        apply(bufnr)
      end, 100)
    end,
  })
  apply(bufnr)
end

return M
