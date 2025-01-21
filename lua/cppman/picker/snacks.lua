return {
  ---@param opts cppman.picker.Opts
  pick = function(opts)
    local actions = vim.deepcopy(opts.actions)
    for k, action in pairs(actions or {}) do
      actions[k] = function(picker, item)
        action(picker, item.value)
      end
    end

    Snacks.picker({
      items = vim
        .iter(opts.items)
        ---@param item cppman.Item
        :map(function(item)
          if not item.keyword then
            vim.print(item)
          end
          return { value = item, text = item.keyword }
        end)
        :totable(),
      format = function(item)
        return { { item.text, "SnacksPickerLabel" } }
      end,
      confirm = function(picker, item)
        picker:close()
        opts.confirm(picker, item.value)
      end,
      preview = function(ctx)
        Snacks.picker.preview.cmd({
          "cppman",
          "--force-columns=" .. vim.fn.winwidth(vim.api.nvim_win_get_number(ctx.preview.win.win)) - 4,
          ctx.item.text,
        }, ctx, { ft = "man" })

        require("cppman.utils").highlight(vim.api.nvim_win_get_buf(ctx.preview.win.win))
      end,
      win = { input = { keys = opts.keys } },
      actions = actions,
    })
  end,
  ---@param picker snacks.Picker
  close = function(picker)
    picker:close()
  end,
}
