---@class Cppman.Config
---@field position string
---@field index_db_path string
local M = {
  position = "split",
  index_db_path = vim.fs.joinpath(vim.fn.stdpath("data"), "cppman.db"),
}

M.setup = function(opts)
  M = vim.tbl_deep_extend("force", M, opts or {})
  return M
end

return M
