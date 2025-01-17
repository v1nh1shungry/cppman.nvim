local M = {}

local config = require("cppman.config")
local index = require("cppman.index")

---@param entries string[]
local function pick(entries)
  require("cppman.picker." .. config.get().picker)(entries)
end

---@param opts Cppman.Config
M.setup = function(opts)
  config.setup(opts)
end

M.fetch_index = function()
  index.fetch()
end

M.search = function()
  if index.is_fetching() then
    return
  end

  pick(index.entries)
end

---@param keyword string
---@param pick_first? boolean
M.open = function(keyword, pick_first)
  if index.is_fetching() then
    return
  end

  keyword = keyword or ""

  local entries = {}
  for _, entry in ipairs(index.entries) do
    if string.find(entry, keyword, 1, true) then
      entries[#entries + 1] = entry
    end
  end

  if #entries == 0 then
    require("cppman.utils").error("No manual for [" .. keyword .. "]")
  elseif #entries == 1 or pick_first then
    require("cppman.display")(entries[1])
  else
    pick(entries)
  end
end

return M
