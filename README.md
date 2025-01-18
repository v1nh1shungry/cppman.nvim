# cppman.nvim

Search and view the [cppreference](https://en.cppreference.com/) manuals on the fly, in your favorite editor!

![demo](https://user-images.githubusercontent.com/98312435/256980587-be86148a-1e35-4b2a-85d0-f905782746ab.gif)

## ✨ Features

* View the manuals right inside the neovim.

* Search in all manuals on the fly. What you can expect from [a vscode extension](https://github.com/Guyutongxue/VSC_CppReference) or [a browser extension](https://github.com/huhu/cpp-search-extension) is now available in neovim!

* `K` keymap support. In the manual you can press `K` and jump to the manual for `<cword>`.

## 📋 Requirements

* NVIM >= 0.10.
* [cppman](https://github.com/aitjcize/cppman)
* `sqlite3`, used to query the index database.

## 📦 Installation

[lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{
  "v1nh1shungry/cppman.nvim",
  cmd = "Cppman",
  dependencies = "nvim-telescope/telescope.nvim", -- optional for telescope picker
  opts = {}, -- required, `setup()` must be called
}
```

## ⚙️ Configuration

```lua
-- default
require('cppman').setup {
  -- * builtin: `vim.ui.select()`
  -- * telescope
  picker = "builtin",
  -- used in `vim.api.nvim_open_win`
  win_opts = {
    split = "below",
    style = "minimal",
  },
}
```

**NOTE**: `$XDG_CACHE_HOME/cppman/index.db` will be used if it exists, because this one is more likely to be the latest. When you run `cppman -r`, `cppman` will rebuild the index database and store it in `$XDG_CACHE_HOME/cppman/index.db`.

## 🚀 Usage

## API

* `require('cppman').search()`: Search in all manuals. Use `telescope.nvim` if available, otherwise use `vim.ui.select()`.

* `require('cppman').open(keyword, list_all?)`: find entries contain keyword, if there're multiple matches, the very first one will be picked. Set `list_all` to true can list all matches.

## Command

* `:Cppman [keyword]`: calling with no argument will act like `search`, otherwise `open`.
