local os = vim.uv.os_uname().sysname
if os ~= "Linux" then
  require("cppman.utils").error(os .. " is not supported")
  return
end

require("cppman.index").setup()

vim.api.nvim_create_user_command("Cppman", function(args)
  local nargs = tonumber(args.nargs)
  if nargs == 0 then
    require("cppman").search()
  else
    require("cppman").open(args.args)
  end
end, {
  bang = false,
  nargs = "*",
})
