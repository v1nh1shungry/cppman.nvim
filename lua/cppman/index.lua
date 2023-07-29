local M = {}
local info = require('cppman.utils').info

-- TODO: cross-platform support (path joining, plenary.nvim may be useful)
local cache_home = os.getenv('XDG_CACHE_HOME') or (os.getenv('HOME') .. '/.cache')
local cache_dir = cache_home .. '/cppman'
local index_db = cache_dir .. '/index.db'
if vim.fn.filereadable(index_db) == 0 then
  index_db = require('cppman.config').options.index_db_path
end

local job = nil

M.entries = {}

M.setup = function()
  if vim.fn.filereadable(index_db) == 0 then
    M.fetch()
  else
    local sqlite = require('sqlite')
    M.entries = sqlite.with_open(index_db, function(db)
      return db:eval [[
SELECT t1.title, t2.keyword
FROM "cppreference.com" AS t1
JOIN "cppreference.com_keywords" AS t2
WHERE t1.id = t2.id
      ]]
    end)
  end
end

M.is_fetching = function()
  if job and not job:is_closing() then
    info 'Fetching the latest index, please wait until it finishes'
    return true
  end
  return false
end

M.fetch = function()
  if M.is_fetching() then
    return
  end
  job = vim.system({
    'curl',
    'https://raw.githubusercontent.com/aitjcize/cppman/master/cppman/lib/index.db',
    '--output',
    index_db,
  }, {}, vim.schedule_wrap(function(res)
    if res.code == 0 then
      info('Successfully fetch the latest index')
      M.setup()
    else
      require('cppman.utils').error("Can't fetch the index:\n" .. res.stderr)
    end
  end))
end

return M