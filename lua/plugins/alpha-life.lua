return {
  "goolord/alpha-nvim",
  opts = function(_, opts)
    local dashboard = require("alpha.themes.dashboard")

    ----------------------------------------------------------------------
    -- 配置 (Config)
    ----------------------------------------------------------------------
    local Config = {
      width_ratio = 0.8,
      height_ratio = 0.8,
      min_width = 10,
      min_height = 20,

      alive_char = "❑",
      dead_char = " ",

      fps = 8,
      init_alive_prob = 0.18,

      -- 自动重新初始化帧数 (例如: 8帧/秒 * 90秒 = 720帧)
      restart_interval = 720,

      -- 生命字符的颜色序列（可自由修改HEX色值）
      colors = {
        "#7e9cd8", -- 蓝色
        "#8b8fcf", -- 蓝紫色过渡
        "#957fb8", -- 紫色
        "#b375a4", -- 紫红色过渡
        "#d27e99", -- 粉红色
        "#e04c7c", -- 粉红到红色的过渡
        "#e82424", -- 红色
        "#f35e2c", -- 红到橙色的过渡
        "#ff7c3c", -- 橙色
        "#ff9452", -- 橙到浅橙的过渡
        "#ffa066", -- 浅橙色
        "#f8b97c", -- 浅橙到淡黄的过渡
        "#e6c384", -- 淡黄色
        "#d6cf86", -- 黄到黄绿的过渡
        "#c3d288", -- 黄绿色
        "#a6cb89", -- 黄绿到绿色的过渡
        "#98bb6c", -- 绿色
        "#86b6a5", -- 绿到青的过渡
        "#7aa89f", -- 青色
        "#6c9cbe", -- 青到蓝的过渡（回到起点）
      },
      padding_x = 2,
      button_spacing = 1,

      buttons = {
        { key = "e", text = "  New file", cmd = "<cmd>ene<CR>" },
        { key = "f", text = "  Find file", cmd = "<cmd>Telescope find_files<CR>" },
        { key = "r", text = "  Recent files", cmd = "<cmd>Telescope oldfiles<CR>" },
        { key = "p", text = "  Projects", cmd = "<cmd>Telescope project<CR>" },
        { key = "c", text = "  Config", cmd = "<cmd>Telescope find_files cwd=~/.config/nvim<CR>" },
        { key = "q", text = "  Quit", cmd = "<cmd>qa<CR>" },
      },
    }

    ----------------------------------------------------------------------
    -- 核心：动态单元格宽度对齐 (防止多字节字符导致的错位)
    ----------------------------------------------------------------------
    local alive_w = vim.fn.strdisplaywidth(Config.alive_char)
    local dead_w = vim.fn.strdisplaywidth(Config.dead_char)
    local cell_w = math.max(1, math.max(alive_w, dead_w))

    local alive_str = Config.alive_char .. string.rep(" ", cell_w - alive_w)
    local dead_str = Config.dead_char .. string.rep(" ", cell_w - dead_w)
    local alive_bytes = #alive_str
    local dead_bytes = #dead_str

    local function safe_bar(char, target_w)
      local w = vim.fn.strdisplaywidth(char)
      if w == 0 then
        return string.rep(" ", target_w)
      end
      local count = math.floor(target_w / w)
      return string.rep(char, count) .. string.rep(" ", target_w - (count * w))
    end

    ----------------------------------------------------------------------
    -- button block 构建 (精确映射到网格)
    ----------------------------------------------------------------------
    local function build_button_block()
      local raw = {}
      local max_text_w = 0

      for _, b in ipairs(Config.buttons) do
        table.insert(raw, { text = b.text, key = b.key })
        max_text_w = math.max(max_text_w, vim.fn.strdisplaywidth(b.text))
      end

      local lines_data = {}
      for _, b in ipairs(raw) do
        local text_w = vim.fn.strdisplaywidth(b.text)
        local pad_spaces = max_text_w - text_w
        local line = string.format("%s%s   [%s]", b.text, string.rep(" ", pad_spaces), b.key)
        table.insert(lines_data, line)
        for _ = 1, Config.button_spacing do
          table.insert(lines_data, "")
        end
      end
      -- 移除最后多余的间距（仅当最后一行确实是空白间距时）
      if #lines_data > 0 and lines_data[#lines_data] == "" then
        table.remove(lines_data)
      end

      local max_line_w = 0
      for _, l in ipairs(lines_data) do
        max_line_w = math.max(max_line_w, vim.fn.strdisplaywidth(l))
      end

      local req_inner_w = max_line_w + Config.padding_x * 2
      local border_w = vim.fn.strdisplaywidth("┌") + vim.fn.strdisplaywidth("┐")
      local req_total_w = req_inner_w + border_w

      -- 将像素/显示宽度强制转换为标准网格宽度的整数倍
      local bw_cells = math.ceil(req_total_w / cell_w)
      local final_total_w = bw_cells * cell_w
      local inner_w = final_total_w - border_w

      local block_lines = {}
      table.insert(block_lines, "┌" .. safe_bar("─", inner_w) .. "┐")

      for _, l in ipairs(lines_data) do
        if l ~= "" then
          local l_w = vim.fn.strdisplaywidth(l)
          local pad_r = math.max(0, inner_w - l_w - Config.padding_x)
          local padded = string.rep(" ", Config.padding_x) .. l .. string.rep(" ", pad_r)
          table.insert(block_lines, "│" .. padded .. "│")
        else
          table.insert(block_lines, "│" .. string.rep(" ", inner_w) .. "│")
        end
      end
      table.insert(block_lines, "└" .. safe_bar("─", inner_w) .. "┘")

      return block_lines, bw_cells
    end

    local block, bw_cells = build_button_block()

    ----------------------------------------------------------------------
    -- 动态尺寸与布局参数更新
    ----------------------------------------------------------------------
    local function compute_size()
      local raw_W = math.max(Config.min_width, math.floor(vim.o.columns * Config.width_ratio))
      -- 保证屏幕始终比 Button Block 宽
      local final_W = math.max(raw_W, bw_cells + 4)
      local final_H = math.max(Config.min_height, math.floor(vim.o.lines * Config.height_ratio))
      return final_H, final_W
    end

    local H, W = compute_size()
    local btn_top, btn_bottom, btn_left, btn_right

    local function update_layout_vars()
      btn_top = math.floor(H / 2) - math.floor(#block / 2)
      btn_bottom = btn_top + #block - 1
      btn_left = math.floor((W - bw_cells) / 2)
      btn_right = btn_left + bw_cells - 1
    end

    update_layout_vars()

    local function compute_top_pad()
      return math.max(0, math.floor((vim.o.lines - H) / 2) - 2)
    end

    ----------------------------------------------------------------------
    -- 演算网格初始化与更新
    ----------------------------------------------------------------------
    local function new_grid()
      local g = {}
      for i = 1, H do
        g[i] = {}
        for j = 1, W do
          g[i][j] = (math.random() < Config.init_alive_prob) and 1 or 0
        end
      end
      return g
    end

    local grid = new_grid()

    local function step(g)
      local ng = {}
      for i = 1, H do
        ng[i] = {}
        for j = 1, W do
          local is_btn = i >= btn_top and i <= btn_bottom and j >= btn_left and j <= btn_right

          if is_btn then
            ng[i][j] = 0
          else
            local cnt = 0
            for di = -1, 1 do
              for dj = -1, 1 do
                if not (di == 0 and dj == 0) then
                  local ni, nj = i + di, j + dj
                  if ni >= 1 and ni <= H and nj >= 1 and nj <= W then
                    cnt = cnt + g[ni][nj]
                  end
                end
              end
            end
            if g[i][j] == 1 then
              ng[i][j] = (cnt == 2 or cnt == 3) and 1 or 0
            else
              ng[i][j] = (cnt == 3) and 1 or 0
            end
          end
        end
      end
      return ng
    end

    ----------------------------------------------------------------------
    -- 终极渲染系统 (完全接管居中控制权与高亮偏移)
    ----------------------------------------------------------------------
    local function render(g)
      local lines, hl = {}, {}

      for i = 1, H do
        local row_chars = {}
        local row_hls = {}
        local line_bytes = 0
        local line_disp = 0

        local function add_cell(is_alive)
          if is_alive then
            table.insert(row_chars, alive_str)
            table.insert(row_hls, { "AlphaLifeAlive", line_bytes, line_bytes + alive_bytes })
            line_bytes = line_bytes + alive_bytes
          else
            table.insert(row_chars, dead_str)
            line_bytes = line_bytes + dead_bytes
          end
          line_disp = line_disp + cell_w
        end

        if i >= btn_top and i <= btn_bottom then
          local idx = i - btn_top + 1
          local txt = block[idx]

          for j = 1, btn_left - 1 do
            add_cell(g[i][j] == 1)
          end

          table.insert(row_chars, txt)
          local txt_bytes = #txt
          table.insert(row_hls, { "AlphaLifeButton", line_bytes, line_bytes + txt_bytes })
          line_bytes = line_bytes + txt_bytes
          line_disp = line_disp + vim.fn.strdisplaywidth(txt)

          for j = btn_right + 1, W do
            add_cell(g[i][j] == 1)
          end
        else
          for j = 1, W do
            add_cell(g[i][j] == 1)
          end
        end

        local raw_line = table.concat(row_chars)
        -- 精确的手动屏幕居中
        local margin = math.max(0, math.floor((vim.o.columns - line_disp) / 2))

        lines[i] = string.rep(" ", margin) .. raw_line

        -- 根据前置的空格数量(margin就是对应的字节数)，精确偏移高亮区间
        local shifted_hls = {}
        for _, h in ipairs(row_hls) do
          table.insert(shifted_hls, { h[1], h[2] + margin, h[3] + margin })
        end

        -- 关键：alpha.nvim 要求 hl[1][1] 必须是 table 才不会走错分支。
        -- 如果某行没有任何高亮（全 dead + 不在 button 区），
        -- alpha 会把整个 hl 当单行处理，导致 hl_section[3] = nil 崩溃。
        -- → 空行塞一个 0 宽度的占位高亮，不影响显示但保证结构合法。
        if #shifted_hls == 0 then
          local dummy_pos = margin + #raw_line
          table.insert(shifted_hls, { "Normal", dummy_pos, dummy_pos })
        end

        hl[i] = shifted_hls
      end

      return lines, hl
    end

    ----------------------------------------------------------------------
    -- 初始化 Layout
    ----------------------------------------------------------------------
    local top_padding = { type = "padding", val = compute_top_pad() }

    local lines, hl = render(grid)
    -- 核心：禁用Alpha自动居中(设定为left)，直接应用我们已经补偿好的字符串和高亮数组！
    dashboard.section.header.opts = { position = "left", hl = hl }
    dashboard.section.header.val = lines

    opts.layout = {
      top_padding,
      dashboard.section.header,
    }

    ----------------------------------------------------------------------
    -- 动画与生命周期
    ----------------------------------------------------------------------
    local alpha_group = vim.api.nvim_create_augroup("AlphaLife", { clear = true })

    vim.api.nvim_create_autocmd("User", {
      group = alpha_group,
      pattern = "AlphaReady",
      once = true,
      callback = function()
        local timer = vim.loop.new_timer()
        local buf = vim.api.nvim_get_current_buf()
        local step_count = 0

        for _, b in ipairs(Config.buttons) do
          vim.keymap.set("n", b.key, b.cmd, { buffer = buf, silent = true })
        end

        -- 挂载 fallback 样式确保不可见时退回到主题文字颜色
        vim.api.nvim_set_hl(0, "AlphaLifeButton", { fg = "#7e9cd8", bold = false })
        vim.api.nvim_set_hl(0, "AlphaLifeAlive", { fg = Config.colors[1], bold = true })

        -- 缓冲区卸载时停止 timer，防止内存泄漏
        vim.api.nvim_create_autocmd("BufUnload", {
          group = alpha_group,
          buffer = buf,
          callback = function()
            if timer and not timer:is_closing() then
              timer:stop()
              timer:close()
            end
          end,
        })

        timer:start(
          0,
          math.floor(1000 / Config.fps),
          vim.schedule_wrap(function()
            if not vim.api.nvim_buf_is_valid(buf) then
              if not timer:is_closing() then
                timer:stop()
                timer:close()
              end
              return
            end

            if vim.api.nvim_get_current_buf() ~= buf then
              return
            end

            step_count = step_count + 1

            -- 动态更改存活细胞的颜色
            local color_idx = (math.floor(step_count / 5) % #Config.colors) + 1
            vim.api.nvim_set_hl(0, "AlphaLifeAlive", { fg = Config.colors[color_idx], bold = true })
            color_idx = (color_idx - 1) % #Config.colors + 1
            vim.api.nvim_set_hl(0, "AlphaLifeButton", { fg = Config.colors[color_idx], bold = false })

            -- 屏幕尺寸变化侦测处理
            local newH, newW = compute_size()
            if newW ~= W or newH ~= H then
              H, W = newH, newW
              update_layout_vars()
              top_padding.val = compute_top_pad()
              grid = new_grid()
              step_count = 0
            end

            -- 自动重新初始化机制
            if step_count >= Config.restart_interval then
              grid = new_grid()
              step_count = 0
            else
              grid = step(grid)
            end

            -- 渲染应用
            local l, h = render(grid)
            dashboard.section.header.val = l
            dashboard.section.header.opts.hl = h

            pcall(vim.cmd, "AlphaRedraw")
          end)
        )
      end,
    })

    return opts
  end,
}
