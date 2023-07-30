local M = {}

M.options = {
  position = 'split',
  index_db_path = vim.fs.joinpath(vim.fn.stdpath('data'), 'cppman.db'),
}

M.setup = function(opts)
  M.options = vim.tbl_deep_extend('force', M.options, opts)
  return M.options
end

return M
