return function(entries)
  local utils = require("cppman.utils")
  Snacks.picker({
    items = vim
      .iter(entries)
      :map(function(e)
        return { text = e }
      end)
      :totable(),
    format = function(item)
      return { { item.text, "SnacksPickerLabel" } }
    end,
    confirm = function(picker, item)
      picker:close()
      utils.display(item.text)
    end,
    preview = function(ctx)
      Snacks.picker.preview.cmd({
        "cppman",
        "--force-columns=" .. vim.fn.winwidth(vim.api.nvim_win_get_number(ctx.preview.win.win)) - 4,
        ctx.item.text,
      }, ctx, { ft = "man" })

      utils.highlight(vim.api.nvim_win_get_buf(ctx.preview.win.win))
    end,
  })
end
