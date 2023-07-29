local display = require('cppman.display')

local builtin = function(entries)
  vim.ui.select(entries, {
    prompt = 'cppman',
    format_item = function(entry) return entry.keyword end,
  }, function(choice)
    if choice then
      display(choice.keyword)
    end
  end)
end

local telescope = function(entries)
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local conf = require('telescope.config').values
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')
  local opts = require('telescope.themes').get_dropdown {}

  pickers.new(opts, {
    prompt_title = 'cppman',
    sorter = conf.generic_sorter(opts),
    finder = finders.new_table {
      results = entries,
      entry_maker = function(entry)
        return {
          value = entry.keyword,
          display = entry.keyword,
          ordinal = entry.keyword,
        }
      end,
    },
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
