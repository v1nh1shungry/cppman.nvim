local utils = require("cppman.utils")

---@class Cppman.Config
---@field position? "split" | "vsplit"
---@field picker "builtin" | "telescope"
---@field win_opts vim.api.keyset.win_config
local conf = {
  picker = "builtin",
  win_opts = {
    split = "below",
    style = "minimal",
  },
}

return setmetatable({
  ---@param opts Cppman.Config
  setup = function(opts)
    if opts.position then
      utils.warn('"position" field is deprecated, please use "win_opts" instead')

      opts.win_opts = opts.win_opts or {}
      if opts.position == "split" then
        opts.win_opts.split = vim.o.splitbelow and "below" or "above"
      elseif opts.position == "vsplit" then
        opts.win_opts.split = vim.o.splitright and "right" or "left"
      elseif opts.position == "tab" then
        utils.error("tabpage position is no longer supported, fallback to split")
      end
    end

    conf = vim.tbl_deep_extend("force", conf, opts)

    return conf
  end,
}, {
  __index = function(_, k)
    return conf[k]
  end,
})
