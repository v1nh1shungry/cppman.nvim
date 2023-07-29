local M = {}
local index = require('cppman.index')
local finder = require('cppman.finder')

local has_setup = false
local check_setup = function()
  if not has_setup then
    require('cppman.utils').error("The plugin has not setup, please execute `require('cppman').setup()`")
    return false
  end
  return true
end

M.setup = function(opts)
  require('cppman.config').setup(opts)
  index.setup()
  has_setup = true
end

M.fetch_index = function()
  if not check_setup() then
    return
  end
  index.fetch()
end

M.search = function()
  if not check_setup() then
    return
  end
  if index.is_fetching() then
    return
  end
  finder(index.entries)
end

M.open = function(keyword)
  if not check_setup() then
    return
  end
  if index.is_fetching() then
    return
  end
  local entries = {}
  keyword = keyword or ''
  for _, entry in ipairs(index.entries) do
    if string.find(entry.keyword, keyword) then
      entries[#entries + 1] = entry
    end
  end
  if #entries == 0 then
    require('cppman.utils').miss(keyword)
  elseif #entries == 1 then
    require('cppman.display')(entries[1].keyword)
  else
    finder(entries)
  end
end

return M
