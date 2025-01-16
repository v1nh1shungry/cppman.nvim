local M = {}

local utils = require("cppman.utils")

local CACHE_HOME = os.getenv("XDG_CACHE_HOME") or vim.fs.joinpath(os.getenv("HOME"), ".cache")
local CACHE_DIR = vim.fs.joinpath(CACHE_HOME, "cppman")

local index_db_path = vim.fs.joinpath(CACHE_DIR, "index.db")
index_db_path = vim.fn.filereadable(index_db_path) == 1 and index_db_path or require("cppman.config").get().index_db_path

---@type vim.SystemObj
local job = nil

---@type string[]
M.entries = {}

M.setup = function()
  if vim.fn.filereadable(index_db_path) == 0 then
    M.fetch()
  else
    vim
      .system({
        "sqlite3",
        index_db_path,
        'SELECT keyword FROM "cppreference.com_keywords";',
      }, { text = true }, function(res)
        if res.code ~= 0 then
          utils.error("Failed to load index: " .. res.stderr)
        end

        M.entries = vim.split(res.stdout, "\n")
      end)
      :wait()
  end
end

M.is_fetching = function()
  if job and not job:is_closing() then
    utils.info("Fetching the latest index, please wait until it finishes")
    return true
  end
  return false
end

M.fetch = function()
  if M.is_fetching() then
    return
  end

  utils.info("Fetching cppman index...")

  job = vim.system(
    {
      "curl",
      "https://raw.githubusercontent.com/aitjcize/cppman/master/cppman/lib/index.db",
      "--output",
      index_db_path,
    },
    {},
    vim.schedule_wrap(function(res)
      if res.code == 0 then
        utils.info("Successfully fetch the latest index")
        M.setup()
      else
        require("cppman.utils").error("Can't fetch the index:\n" .. res.stderr)
      end
    end)
  )
end

return M
