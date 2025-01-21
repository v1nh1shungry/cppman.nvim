return {
  ---@param opts cppman.picker.Opts
  pick = function(opts)
    vim.ui.select(opts.items, {
      prompt = "cppman",
      ---@param item cppman.Item
      format_item = function(item)
        return item.keyword
      end,
    }, function(choice)
      if choice then
        require("cppman.utils").display(choice.keyword)
      end
    end)
  end,
}
