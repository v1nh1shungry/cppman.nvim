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

-- https://github.com/nvim-telescope/telescope.nvim/issues/1923#issuecomment-1122642431
local get_selection = function()
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg("v")
  vim.fn.setreg("v", {})
  return string.gsub(text, "\n", "")
end

-- TODO: Check compatibility, versions
local function cppman(keyword)
  local config = require("cppman.config")

  if config.position == "tab" then
    vim.cmd("tab split")
  else
    local avail = -1
    for i = 1, vim.fn.winnr("$") do
      local nr = vim.fn.winbufnr(i)
      if vim.b[nr].cppman then
        avail = i
      end
    end
    if avail > 0 then
      vim.cmd.exec(string.format("'%d wincmd w'", avail))
    else
      if config.position == "vsplit" then
        vim.cmd.vsplit()
      else
        vim.cmd.split()
      end
    end
  end

  vim.system(
    {
      "cppman",
      "--force-columns=" .. vim.fn.winwidth(0) - 2,
      keyword,
    },
    {},
    vim.schedule_wrap(function(r)
      if string.find(r.stdout, "No manual entry for") then
        require("cppman.utils").miss(keyword)
        return
      end

      local content = vim.split(r.stdout, "\n")
      local win = vim.api.nvim_get_current_win()

      local page_uri = "man://cppman/" .. keyword
      local buf = -1
      for _, i in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_name(i) == page_uri then
          buf = i
        end
      end
      if buf < 0 then
        buf = vim.api.nvim_create_buf(false, true)
      end

      local bo = vim.bo[buf]
      local wo = vim.wo[win]

      bo.buftype = "nofile"
      bo.swapfile = false
      bo.bufhidden = "hide"
      bo.ft = "man"
      bo.readonly = false
      bo.modifiable = true
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
      vim.api.nvim_buf_set_name(buf, page_uri)
      bo.readonly = true
      bo.modifiable = false
      vim.b[buf].cppman = true

      vim.api.nvim_win_set_buf(win, buf)
      wo.number = false
      wo.relativenumber = false
      wo.signcolumn = "no"
      wo.colorcolumn = "0"
      wo.statuscolumn = ""

      setup_highlight()

      vim.keymap.set("n", "K", function() cppman(vim.fn.expand("<cword>")) end, { buffer = buf })
      vim.keymap.set("v", "K", function() cppman(get_selection()) end, { buffer = buf })
    end)
  )
end

return cppman
