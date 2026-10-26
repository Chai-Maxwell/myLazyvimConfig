-- blink-cmp-dictionary 的包装：
-- 1) 给每个候选附加"本地使用次数 + 全局词频排名"作为 sortText，让 blink
--    在模糊匹配分数相同时先按本地使用次数、再按全局词频排序
--    （blink 默认 sorts = { "score", "sort_text" }）。
-- 2) 记录词典补全被接受的次数，供菜单最右端显示本地使用次数。
local DictSource = require("blink-cmp-dictionary")

local M = {}

local ranks ---@type table<string, integer>|nil
local max_rank = 99999999

-- 本地使用次数：{ [小写单词] = 次数 }，持久化到 state 目录
local counts ---@type table<string, integer>|nil
local counts_dirty = false
local save_scheduled = false

local function counts_path()
  return vim.fn.stdpath("state") .. "/dict_freq_counts.json"
end

local function load_counts()
  if counts then return counts end
  counts = {}
  local f = io.open(counts_path(), "r")
  if f then
    local ok, decoded = pcall(vim.json.decode, f:read("*a"))
    f:close()
    if ok and type(decoded) == "table" then counts = decoded end
  end
  return counts
end

local function save_counts()
  if not counts_dirty then return end
  counts_dirty = false
  local f = io.open(counts_path(), "w")
  if not f then return end
  local ok, encoded = pcall(vim.json.encode, load_counts())
  if ok then f:write(encoded) end
  f:close()
end

local function schedule_save()
  counts_dirty = true
  if save_scheduled then return end
  save_scheduled = true
  vim.defer_fn(function()
    save_scheduled = false
    save_counts()
  end, 2000)
end

--- 某个词在本机的使用次数
--- @param label string
--- @return integer
function M.local_count(label)
  if type(label) ~= "string" or label == "" then return 0 end
  return load_counts()[label:lower()] or 0
end

local function load_ranks()
  if ranks then return ranks end
  ranks = {}
  local path = vim.fn.expand("~/.config/nvim/dictionary/words.txt")
  local f = io.open(path, "r")
  if not f then return ranks end
  local i = 0
  for line in f:lines() do
    i = i + 1
    if line ~= "" then ranks[line] = i end
  end
  f:close()
  return ranks
end

local function sort_key(label)
  local key = label:lower()
  local rank = load_ranks()[key] or max_rank
  local count = load_counts()[key] or 0
  -- 本地次数降序优先，其次全局词频排名升序；固定宽度保证字典序等于数值序
  return string.format("%06d%08d", math.max(0, 999999 - count), rank)
end

-- 记录被接受的词典候选。用 blink 的 User 事件而不是内部模块，
-- 这样无论通过 <CR>/<Tab>/<C-y> 接受都能统计到。
vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpAccept",
  callback = function(ev)
    local item = ev.data and ev.data.item
    if not item or item.source_id ~= "dictionary" then return end
    local key = item.label:lower()
    local c = load_counts()
    c[key] = (c[key] or 0) + 1
    schedule_save()
  end,
})

vim.api.nvim_create_autocmd("VimLeavePre", { callback = save_counts })

function M.new(opts, config)
  local inner = DictSource.new(opts, config)
  local self = setmetatable({}, { __index = inner })

  function self:get_completions(context, callback)
    return inner:get_completions(context, function(response)
      if response and response.items then
        for _, item in ipairs(response.items) do
          item.sortText = sort_key(item.label)
        end
      end
      callback(response)
    end)
  end

  return self
end

return M
