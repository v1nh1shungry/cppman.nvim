local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")

return function(entries)
  pickers
    .new({}, {
      prompt_title = "cppman",
      sorter = conf.generic_sorter({}),
      finder = finders.new_table({ results = entries }),
      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          require("cppman.display")(selection.value)
        end)
        return true
      end,
    })
    :find()
end
