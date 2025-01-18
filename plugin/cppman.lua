vim.api.nvim_create_user_command("Cppman", function(args)
  if args.args == "" then
    require("cppman").search()
  else
    require("cppman").open(args.args, true)
  end
end, {
  bang = false,
  nargs = "*",
})
