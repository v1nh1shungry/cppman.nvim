local M = {}

local log = function(msg, level) vim.notify(msg, level, { title = "cppman.nvim" }) end

M.info = function(msg) log(msg, vim.log.levels.INFO) end

M.error = function(msg) log(msg, vim.log.levels.ERROR) end

M.miss = function(entry) M.error("No manual for [" .. entry .. "]") end

return M
