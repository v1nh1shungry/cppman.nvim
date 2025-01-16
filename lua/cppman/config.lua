local utils = require("cppman.utils")

---@class Cppman.Config
---@field position? "split" | "vsplit"
---@field index_db_path string
---@field picker "builtin" | "telescope"
---@field win_opts vim.api.keyset.win_config
local conf = {
  index_db_path = vim.fs.joinpath(vim.fn.stdpath("data"), "cppman.db"),
  picker = "builtin",
  win_opts = {
    split = "below",
    style = "minimal",
  },
}

local M = {}

---@param opts Cppman.Config
function M.setup(opts)
  opts = opts or {}
  if opts.position then
    utils.warn('"position" field is deprecated, please use "win_opts" instead')
    if opts.position == "tab" then
      utils.error("tabpage position is no longer supported, fallback to split")
    end
  end

  conf = vim.tbl_deep_extend("force", conf, opts)

  return conf
end

function M.get()
  return conf
end

return M
