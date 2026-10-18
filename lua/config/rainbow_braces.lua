-- lua/config/rainbow_braces.lua
-- rainbow braces：花括号按嵌套层级着色
--   .tex/.latex：整文件按 latex 解析
--   .md：对 $...$ / $$...$$ 数学块（与 markdown-preview 一致）内的花括号着色
-- 转义 \{\} 与注释内括号由 latex 语法结构天然排除（不是 { } token）
local M = {}

-- 循环方向：最外层 = RainbowBrace4（橄榄金），每深入一层索引 -1，4 级循环
local HL = {
  "RainbowBrace1",
  "RainbowBrace2",
  "RainbowBrace3",
  "RainbowBrace4",
}
local ns = vim.api.nvim_create_namespace("latex_rainbow_braces")

-- 遍历一棵 latex 语法树，给 { } token 按深度上色。
-- root 的相对 (0,0) 对应缓冲区绝对位置 (base_row, base_col)；整缓冲区树时 base 为 0,0。
local function color_latex_tree(bufnr, root, base_row, base_col)
  local depth = 0
  local function walk(node)
    local t = node:type()
    if t == "{" or t == "}" then
      local row, col = node:start() -- 相对 root 原点的 0-indexed (row, byte col)
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
      local abs_row = base_row + row
      local abs_col = (row == 0) and (base_col + col) or col
      vim.api.nvim_buf_set_extmark(bufnr, ns, abs_row, abs_col, {
        end_col = abs_col + 1,
        hl_group = grp,
        priority = 200,
      })
      return
    end
    for child in node:iter_children() do
      walk(child)
    end
  end
  walk(root)
end

-- .tex/.latex：整文件解析为 latex
local function apply_tex(bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "latex")
  if not ok then
    return
  end
  color_latex_tree(bufnr, parser:parse()[1]:root(), 0, 0)
end

-- .md：找出所有 $...$ / $$...$$ 数学块，逐块解析为 latex 并上色
local function apply_markdown(bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "markdown")
  if not ok then
    return
  end
  local root = parser:parse()[1]:root()

  -- 收集所有 inline 节点（fenced/indented 代码块不在 inline 内，天然被跳过）
  local inlines = {}
  local function collect(node)
    if node:type() == "inline" then
      inlines[#inlines + 1] = node
      return
    end
    for child in node:iter_children() do
      collect(child)
    end
  end
  collect(root)

  for _, inline in ipairs(inlines) do
    local text = vim.treesitter.get_node_text(inline, bufnr)
    if text ~= "" then
      local ir, ic = inline:start() -- inline 文本在缓冲区中的绝对起点
      local mok, mp = pcall(vim.treesitter.get_string_parser, text, "markdown_inline")
      if mok then
        local mroot = mp:parse()[1]:root()
        local function find_blocks(node)
          if node:type() == "latex_block" then
            local _, _, sbyte = node:start()
            local _, _, ebyte = node:end_()
            local btext = text:sub(sbyte + 1, ebyte)
            local delim = (btext:sub(1, 2) == "$$") and 2 or 1
            local inner = btext:sub(delim + 1, #btext - delim)
            if #inner > 0 then
              local br, bc = node:start() -- latex_block 相对 inline 文本的位置
              local abs_row = ir + br
              local abs_col = (br == 0) and (ic + bc) or bc
              local lok, lp = pcall(vim.treesitter.get_string_parser, inner, "latex")
              if lok then
                color_latex_tree(bufnr, lp:parse()[1]:root(), abs_row, abs_col + delim)
              end
            end
            return
          end
          for child in node:iter_children() do
            find_blocks(child)
          end
        end
        find_blocks(mroot)
      end
    end
  end
end

function M.attach(bufnr)
  local ft = vim.bo[bufnr].filetype
  local lang, apply_fn
  if ft == "tex" or ft == "latex" then
    lang, apply_fn = "latex", apply_tex
  elseif ft == "markdown" then
    lang, apply_fn = "markdown", apply_markdown
  else
    return
  end
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, lang)
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
        apply_fn(bufnr)
      end, 100)
    end,
  })
  apply_fn(bufnr)
end

return M
