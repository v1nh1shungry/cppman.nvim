local utils = require("cppman.utils")

---@class Cppman.Config
---@field position? "split" | "vsplit"
---@field index_db_path string
---@field picker "builtin" | "telescope"
---@field win_opts vim.api.keyset.win_config
local M = {
  index_db_path = vim.fs.joinpath(vim.fn.stdpath("data"), "cppman.db"),
  picker = "builtin",
  win_opts = {
    split = "below",
    style = "minimal",
  },
}

---@param opts Cppman.Config
M.setup = function(opts)
  opts = opts or {}
  if opts.position then
    utils.warn('"position" field is deprecated, please use "win_opts" instead')
    if opts.position == "tab" then
      utils.error("tabpage position is no longer supported, fallback to split")
    end
  end

  M = vim.tbl_deep_extend("force", M, opts)

  return M
end

return M
