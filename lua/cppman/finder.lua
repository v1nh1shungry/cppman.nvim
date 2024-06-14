local display = require('cppman.display')

local builtin = function(entries)
  vim.ui.select(entries, {
    prompt = 'cppman',
  }, function(choice)
    if choice then
      display(choice)
    end
  end)
end

local telescope = function(entries)
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local conf = require('telescope.config').values
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')

  pickers.new({}, {
    prompt_title = 'cppman',
    sorter = conf.generic_sorter({}),
    finder = finders.new_table { results = entries },
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        display(selection.value)
      end)
      return true
    end,
  }):find()
end

local has_telescope, _ = pcall(require, 'telescope')
if has_telescope then
  return telescope
else
  return builtin
end
