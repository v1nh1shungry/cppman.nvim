local M = {}

local function log (msg, level) vim.notify(msg, level, { title = "cppman.nvim" }) end

function M.info(msg) log(msg, vim.log.levels.INFO) end

function M.warn(msg) log(msg, vim.log.levels.WARN) end

function M.error (msg) log(msg, vim.log.levels.ERROR) end

return M
