local os = vim.uv.os_uname()
if os ~= "Linux" then
  require("cppman.utils").error(os .. " is not supported")
  return
end

require("cppman.index").setup()
