-- TODO: A rough fix for setup sequence, refactor it later
vim.defer_fn(function()
  if not vim.g.loaed_cppman then
    require("cppman").setup()
  end
end, 0)

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
