local M = {}

local finder = require("cppman.finder")
local index = require("cppman.index")

M.setup = function(opts)
  require("cppman.config").setup(opts)
end

M.fetch_index = function()
  index.fetch()
end

M.search = function()
  if index.is_fetching() then
    return
  end
  finder(index.entries)
end

M.open = function(keyword)
  if index.is_fetching() then
    return
  end
  local entries = {}
  keyword = keyword or ""
  for _, entry in ipairs(index.entries) do
    if string.find(entry, keyword) then
      entries[#entries + 1] = entry
    end
  end
  if #entries == 0 then
    require("cppman.utils").miss(keyword)
  elseif #entries == 1 then
    require("cppman.display")(entries[1])
  else
    finder(entries)
  end
end

return M
