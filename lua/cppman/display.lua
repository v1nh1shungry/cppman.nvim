-- https://github.com/aitjcize/cppman/blob/master/cppman/lib/cppman.vim
local setup_highlight = function()
  vim.cmd([[
syntax clear
syntax case ignore
syntax match  manReference       "[a-z_:+-\*][a-z_:+-~!\*<>()]\+ ([1-9][a-z]\=)"
syntax match  manTitle           "^\w.\+([0-9]\+[a-z]\=).*"
syntax match  manSectionHeading  "^[a-z][a-z_ \-:]*[a-z]$"
syntax match  manSubHeading      "^\s\{3\}[a-z][a-z ]*[a-z]$"
syntax match  manOptionDesc      "^\s*[+-][a-z0-9]\S*"
syntax match  manLongOptionDesc  "^\s*--[a-z0-9-]\S*"

syntax include @cppCode runtime! syntax/cpp.vim
syntax match manCFuncDefinition  display "\<\h\w*\>\s*("me=e-1 contained

syntax region manSynopsis start="^SYNOPSIS"hs=s+8 end="^\u\+\s*$"me=e-12 keepend contains=manSectionHeading,@cppCode,manCFuncDefinition
syntax region manSynopsis start="^EXAMPLE"hs=s+7 end="^       [^ ]"he=s-1 keepend contains=manSectionHeading,@cppCode,manCFuncDefinition

hi def link manTitle           Title
hi def link manSectionHeading  Statement
hi def link manOptionDesc      Constant
hi def link manLongOptionDesc  Constant
hi def link manReference       PreProc
hi def link manSubHeading      Function
hi def link manCFuncDefinition Function
  ]])
end

---@type integer?
local buf
---@type integer?
local win

local function display(keyword)
  local config = require("cppman.config").get()

  vim.system(
    {
      "cppman",
      "--force-columns=" .. vim.fn.winwidth(0) - 2,
      keyword,
    },
    nil,
    vim.schedule_wrap(function(r)
      if string.find(r.stdout, "No manual entry for") then
        require("cppman.utils").error("No manual for [" .. keyword .. "]")
        return
      end

      local content = vim.split(r.stdout, "\n")

      if not buf or not vim.api.nvim_buf_is_valid(buf) then
        buf = vim.api.nvim_create_buf(false, true)
      end
      if not win or not vim.api.nvim_win_is_valid(win) then
        win = vim.api.nvim_open_win(buf, true, config.win_opts)
      else
        vim.api.nvim_win_set_buf(win, buf)
      end

      local page_uri = "man://cppman/" .. keyword

      vim.bo[buf].ft = "man"
      vim.bo[buf].modifiable = true
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
      vim.api.nvim_buf_set_name(buf, page_uri)
      vim.bo[buf].modifiable = false
      vim.bo[buf].keywordprg = ":Cppman"

      setup_highlight()

      vim.api.nvim_win_set_cursor(win, { 1, 0 })
    end)
  )
end

return display
