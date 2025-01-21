local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")

return {
  ---@param opts cppman.picker.Opts
  pick = function(opts)
    pickers
      .new({}, {
        prompt_title = "cppman",
        sorter = conf.generic_sorter({}),
        finder = finders.new_table({
          results = opts.items,
          ---@param item cppman.Item
          entry_maker = function(item)
            return {
              value = item,
              display = item.keyword,
              ordinal = item.keyword,
            }
          end,
        }),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            opts.confirm(action_state.get_current_picker(prompt_bufnr), action_state.get_selected_entry().value)
          end)

          for key, mapping in pairs(opts.keys or {}) do
            map(type(mapping) == "string" and "n" or mapping.mode, key, function()
              opts.actions[type(mapping) == "string" and mapping or mapping[1]](
                action_state.get_current_picker(prompt_bufnr),
                action_state.get_selected_entry().value
              )
            end)
          end

          return true
        end,
      })
      :find()
  end,
  ---@param picker Picker
  close = function(picker)
    actions.close(picker.prompt_bufnr)
  end,
}
