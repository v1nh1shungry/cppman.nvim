return function(entries)
  vim.ui.select(entries, {
    prompt = "cppman",
  }, function(choice)
    if choice and vim.trim(choice) ~= "" then
      require("cppman.utils").display(choice)
    end
  end)
end
