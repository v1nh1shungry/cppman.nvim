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

---@param items cppman.Item[]
local function pick(items)
  local Picker = require("cppman.picker." .. conf.picker)
  Picker.pick({
    items = items,
    ---@param item cppman.Item
    confirm = function(_, item)
      utils.display(item.keyword)
    end,
    actions = {
      ---@param item cppman.Item
      open_in_browser = function(picker, item)
        Picker.close(picker)
        vim.ui.open(item.url)
      end,
    },
    keys = { ["<C-o>"] = { "open_in_browser", mode = "i" } },
  })
end

---@type cppman.Item[]
local items = {}

---@param opts? cppman.Config
M.setup = function(opts)
  conf.setup(opts or {})

  vim
    .system(
      {
        "sqlite3",
        "-line",
        index_db_path,
        [[
        SELECT keyword, url
        FROM "cppreference.com" AS a, "cppreference.com_keywords" AS b
        WHERE a.id = b.id;
        ]],
      },
      nil,
      function(res)
        if res.code ~= 0 then
          utils.error("Failed to load index: " .. res.stderr)
        end

        for _, line in ipairs(vim.split(res.stdout, "\n\n", { trimempty = true })) do
          local lines = vim.split(line, "\n", { trimempty = true })
          assert(#lines == 2, "Invalid line: " .. line)

          local keyword = string.match(lines[1], "keyword = (.+)")
          local url = string.match(lines[2], "url = (.+)")

          if keyword and url then
            table.insert(items, {
              keyword = keyword,
              url = url,
            })
          end
        end
      end
    )
    :wait()
end

M.search = function()
  pick(items)
end

---@param keyword string
---@param list_all? boolean
M.open = function(keyword, list_all)
  keyword = keyword or ""

  local matches = vim
    .iter(items)
    :filter(function(e)
      return not not string.find(e, keyword, 1, true)
    end)
    :totable()

  if #matches == 0 then
    utils.error("No manual for [" .. keyword .. "]")
  elseif #matches == 1 or not list_all then
    utils.display(matches[1])
  else
    pick(matches)
  end
end

return M
