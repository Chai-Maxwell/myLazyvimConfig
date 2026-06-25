-- ~/.config/nvim/lua/config/neovide.lua
-- Neovide GUI 专属配置（仅在 Neovide 中生效）

if not vim.g.neovide then
  return
end

-- ═══════════════════════════════════════════════════════════
-- 窗口与外观
-- ═══════════════════════════════════════════════════════════
vim.g.neovide_opacity = 1.0 -- 完全不透明（与 Kitty 背景一致）

-- 暖纸底色：你的主题设了 transparent=true，所有高亮组 bg=NONE。
-- 在 Kitty 中，终端的背景色 #fcf6e5 会透过透明显示；
-- 在 Neovide 中，bg=NONE 让窗口直接透明到桌面，需要用 neovide 专属逻辑补救。
-- UIEnter 在 GUI 完全就绪后才触发，保证不会被主题的 on_highlights 覆盖。
vim.api.nvim_create_autocmd("UIEnter", {
  once = true,
  callback = function()
    vim.api.nvim_set_hl(0, "Normal", { bg = "#fcf6e5" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "#fcf6e5" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#fcf6e5" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "#fcf6e5" })
    vim.api.nvim_set_hl(0, "FoldColumn", { bg = "#fcf6e5" })
    vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "#fcf6e5" })
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#fcf6e5" })
    vim.api.nvim_set_hl(0, "CursorColumn", { bg = "#fcf6e5" })
    vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#fcf6e5" })
  end,
})
vim.g.neovide_scale_factor = 1.0 -- 缩放比例（1.0 = 默认）
vim.g.neovide_fullscreen = false
vim.g.neovide_remember_window_size = true -- 记住窗口大小
vim.g.neovide_input_use_logo = true -- Cmd 键映射到 Super

-- ═══════════════════════════════════════════════════════════
-- 字体：Neovide 0.12.1+ 改由 ~/.config/neovide/config.toml 控制，
-- g:neovide_font_size / g:neovide_font_family 已失效。

-- ═══════════════════════════════════════════════════════════
-- 动画参数
-- ═══════════════════════════════════════════════════════════
vim.g.neovide_scroll_animation_length = 0.15
vim.g.neovide_cursor_animation_length = 0.08
vim.g.neovide_cursor_trail_size = 0.3
-- 光标粒子特效，可选值（6 种内置效果）：
--   "ripple"    - 涟漪扩散
--   "railgun"   - 电磁炮粒子束
--   "torpedo"   - 鱼雷拖尾
--   "pixiedust" - 仙尘光点
--   "sonicboom" - 音爆波纹
--   "wireframe" - 线框立方体
vim.g.neovide_cursor_vfx_mode = "sonicboom"
vim.g.neovide_cursor_vfx_opacity = 60.0 -- 粒子透明度（越低越轻）
vim.g.neovide_cursor_vfx_particle_lifetime = 0.4 -- 粒子生命周期，秒（除 sonicboom/ripple/wireframe 外）
vim.g.neovide_cursor_vfx_particle_highlight_lifetime = 0.2 -- 粒子高亮生命周期，秒（sonicboom/ripple/wireframe）
vim.g.neovide_cursor_vfx_particle_density = 1.0 -- 粒子密度（越低越稀疏）
vim.g.neovide_cursor_vfx_particle_speed = 15.0 -- 粒子移动速度 px/s（默认 10.0）
vim.g.neovide_cursor_short_animation_length = 0.02 -- 打字时短距离动画时长（默认 0.04）

-- ═══════════════════════════════════════════════════════════
-- 禁用与 Neovide 动画系统冲突的插件
-- ═══════════════════════════════════════════════════════════

-- smear-cursor: Neovide 有原生平滑光标，关闭此插件以避免双重视觉叠加
vim.g.smear_cursor_enabled = false

-- mini-animate 的滚动动画可能与 Neovide 自带的滚动动画叠加，
-- 如果你的 lazyvim extras 启用了 mini-animate，此处可选择性禁用：
-- require("mini.animate").setup({ scroll = { enable = false } })
