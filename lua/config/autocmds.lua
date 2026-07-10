-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
-- lua/config/autocmds.lua
-- lua/config/autocmds.lua
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.md",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    -- ============================================================
    -- Step 1: figure[(path)(caption)[(size)]] → <figure> HTML
    --   Runs on full buffer text (1 line shorthand → 4 lines HTML)
    -- ============================================================
    local text = table.concat(lines, "\n")
    local figure_modified = false

    local function normalize_size(s)
      s = s:match("^%s*(.-)%s*$") -- trim
      if s == "" then return nil end
      s = s:gsub("%%$", "") -- strip %, re-add in format
      return s
    end

    -- 3-arg: figure[(path)(caption)(size)]
    local new_text, n3 = text:gsub(
      "figure%[%(([^)]*)%)%(([^)]*)%)%(([^)]*)%)%]",
      function(path, caption, size)
        figure_modified = true
        size = normalize_size(size)
        if size then
          return string.format(
            '<figure class="image-round" style="--image-width:%s%%">\n  <img src="%s">\n  <figcaption>%s</figcaption>\n</figure>',
            size, path, caption
          )
        else
          return string.format(
            '<figure class="image-round">\n  <img src="%s">\n  <figcaption>%s</figcaption>\n</figure>',
            path, caption
          )
        end
      end
    )
    if n3 > 0 then text = new_text end

    -- 2-arg: figure[(path)(caption)]
    local new_text2, n2 = text:gsub(
      "figure%[%(([^)]*)%)%(([^)]*)%)%]",
      function(path, caption)
        figure_modified = true
        return string.format(
          '<figure class="image-round">\n  <img src="%s">\n  <figcaption>%s</figcaption>\n</figure>',
          path, caption
        )
      end
    )
    if n2 > 0 then text = new_text2; figure_modified = true end

    if figure_modified then
      lines = vim.split(text, "\n", { plain = true })
    end

    -- ============================================================
    -- Step 2: KaTeX macro substitution (line-by-line)
    -- ============================================================
    local new_lines = {}
    local in_code_block = false

    for _, line in ipairs(lines) do
      local processed = line

      -- 检测代码块开始/结束
      if processed:match("^```") then
        in_code_block = not in_code_block
        table.insert(new_lines, processed)
        goto continue
      end

      -- 跳过代码块中的内容
      if in_code_block then
        table.insert(new_lines, processed)
        goto continue
      end

      -- 跳过行内代码（简化处理）
      if not processed:match("`.*`") then
        -- 基本 KaTeX 宏替换
        processed = processed:gsub("\\Var", "\\operatorname{Var}")
        processed = processed:gsub("\\Cov", "\\operatorname{Cov}")
        processed = processed:gsub("\\diag", "\\operatorname{diag}")
        processed = processed:gsub("\\upd", "\\mathrm{d}")
        processed = processed:gsub("\\upg", "\\mathrm{g}")
        processed = processed:gsub("\\upe", "\\mathrm{e}")
        processed = processed:gsub("\\upi", "\\mathrm{i}")

        -- 处理多行宏
        processed = processed:gsub("\\leftBrace", "\\left\\{\\begin{aligned}")
        processed = processed:gsub("\\rightEnd", "\\end{aligned}\\right.")

        -- 你原来的复杂宏
        processed = processed:gsub("\\par(%A)", "¶%1")
        processed = processed:gsub("\\part%s*{(.-)}%s*{(.-)}", "\\frac{\\partial %1}{\\partial %2}")
        processed = processed:gsub("\\deri%s*{(.-)}%s*{(.-)}", "\\frac{\\mathrm{d}%1}{\\mathrm{d}%2}")
        processed = processed:gsub("\\dbm%s*{(.-)}", "\\dot{\\bm{%1}}")
        processed = processed:gsub("\\ddbm%s*{(.-)}", "\\ddot{\\bm{%1}}")
        processed =
          processed:gsub("\\partSec%s*{(.-)}%s*{(.-)}%s*{(.-)}", "\\frac{\\partial^2 %1}{\\partial %2 \\partial %3}")
        processed = processed:gsub("\\delt%s*{(.-)}%s*{(.-)}", "\\frac{\\delta %1}{\\delta %2}")
      end

      table.insert(new_lines, processed)
      ::continue::
    end

    -- 更新缓冲区
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)
  end,
})

-- 用 macOS 访达打开当前工作文件夹
vim.api.nvim_create_user_command("OpenInFolder", function()
  vim.fn.jobstart({ "open", vim.fn.getcwd() }, { detach = true })
end, {})

-- 图片文件 → 交给 macOS 预览.app 打开，终端和 Neovide 通用
-- （与 neo-tree 中 PDF 的处理方式一致）
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.{png,jpg,jpeg,gif,bmp,webp,tiff,svg,heic,ico}",
  callback = function()
    local file = vim.fn.expand("%:p")
    if file == "" then
      return
    end
    -- 用 macOS 预览打开
    vim.fn.jobstart({ "open", file }, { detach = true })
    -- 关闭当前 buffer，切回上一个
    vim.cmd("bdelete")
  end,
})
