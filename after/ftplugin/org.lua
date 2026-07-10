-- org 文件中 cit/ciT 是 TODO 状态流转的 chord 快捷键
-- c 键是 Vim 的 change 操作符，需要足够 timeoutlen 才能让它等完整序列
-- LazyVim 默认 300ms 太短，只在 org buffer 中增加到 1000ms
vim.opt_local.timeoutlen = 1000
