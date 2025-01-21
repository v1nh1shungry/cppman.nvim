local utils = require("cppman.utils")

---@type cppman.Config
local conf = {
  picker = "builtin",
  win = {
    split = "below",
    style = "minimal",
  },
}

return setmetatable({
  ---@param opts cppman.Config
  setup = function(opts)
    if opts.position then
      utils.warn('"position" field is deprecated, please use "win_opts" instead')

      opts.win = opts.win or {}
      if opts.position == "split" then
        opts.win.split = vim.o.splitbelow and "below" or "above"
      elseif opts.position == "vsplit" then
        opts.win.split = vim.o.splitright and "right" or "left"
      elseif opts.position == "tab" then
        utils.error("tabpage position is no longer supported, fallback to split")
      end
    end

    if opts.win_opts then
      opts.win = opts.win_opts
      utils.warn('"win_opts" field is deprecated, please use "win" instead')
    end

    conf = vim.tbl_extend("force", conf, opts)

    return conf
  end,
}, {
  __index = function(_, k)
    return conf[k]
  end,
})
