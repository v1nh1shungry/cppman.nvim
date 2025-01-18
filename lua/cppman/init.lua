local M = {}

local conf = require("cppman.config")
local utils = require("cppman.utils")

local LATEST_INDEX_PATH =
  vim.fs.joinpath(vim.env.XDG_CACHE_HOME or vim.fs.joinpath(vim.env.HOME, ".cache"), "cppman", "index.db")

local index_db_path =
  vim.fs.normalize(vim.fs.joinpath(vim.fs.dirname(debug.getinfo(1).source:sub(2)), "..", "..", "assets", "index.db"))
if vim.fn.filereadable(LATEST_INDEX_PATH) == 1 then
  index_db_path = LATEST_INDEX_PATH
end

---@type string[]
local entries = {}

---@param opts? Cppman.Config
M.setup = function(opts)
  conf.setup(opts or {})

  vim
    .system(
      {
        "sqlite3",
        index_db_path,
        'SELECT keyword FROM "cppreference.com_keywords";',
      },
      nil,
      function(res)
        if res.code ~= 0 then
          utils.error("Failed to load index: " .. res.stderr)
        end

        entries = vim.split(res.stdout, "\n")
      end
    )
    :wait()
end

M.search = function()
  require("cppman.picker." .. conf.picker)(entries)
end

---@param keyword string
---@param list_all? boolean
M.open = function(keyword, list_all)
  keyword = keyword or ""

  local matches = vim
    .iter(entries)
    :filter(function(e)
      return not not string.find(e, keyword, 1, true)
    end)
    :totable()

  if #matches == 0 then
    utils.error("No manual for [" .. keyword .. "]")
  elseif #matches == 1 or not list_all then
    require("cppman.display")(matches[1])
  else
    require("cppman.picker." .. conf.picker)(entries)
  end
end

return M
