# cppman.nvim

Search and view the [cppreference](https://en.cppreference.com/) manuals on the fly, in your favorite editor!

![demo](https://user-images.githubusercontent.com/98312435/256980587-be86148a-1e35-4b2a-85d0-f905782746ab.gif)

## ✨ Features

* View the manuals right inside the neovim.

* Search in all manuals on the fly. What you can expect from [a vscode extension](https://github.com/Guyutongxue/VSC_CppReference) or [a browser extension](https://github.com/huhu/cpp-search-extension) is now available in neovim!

* `K` keymap support. In the manual you can press `K` and jump to the manual for `<cword>`.

## 📋 Requirements

1. NVIM >= 0.10.
2. [cppman](https://github.com/aitjcize/cppman)
3. `sqlite3`, used to query the index database.
4. (Optional) `curl`, used to download [the index database](https://raw.githubusercontent.com/aitjcize/cppman/master/cppman/lib/index.db). You can manually download it (if you have already installed `cppman` you can get it from `<cppman-install-directory>/lib/index.db`) and place it in `$HOME/.local/share/nvim/cppman.db` or other directory with [configuration](#Configuration). In this case `curl` is unnecessary.

## 📦 Installation

[lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{
  "v1nh1shungry/cppman.nvim",
  cmd = "Cppman",
  dependencies = "nvim-telescope/telescope.nvim", -- optional for telescope picker
  opts = {},
}
```

## ⚙️ Configuration

```lua
-- default
require('cppman').setup {
  -- * builtin: `vim.ui.select()`
  -- * telescope
  picker = "builtin",
  -- where the index database stores
  -- you can manually set this option to `<cppman-install-directory>/lib/index.db` to avoid downloading
  index_db_path = vim.fs.joinpath(vim.fn.stdpath('data'), 'cppman.db'),
  -- used in `vim.api.nvim_open_win`
  win_opts = {
    split = "below",
    style = "minimal",
  },
}
```

**NOTE**: even if you set `index_db_path`, `$XDG_CACHE_HOME/cppman/index.db` will be used if it exists, because this one is more likely to be the latest. When you run `cppman -r`, `cppman` will rebuild the index database and store it in `$XDG_CACHE_HOME/cppman/index.db`. The index database this plugin downloads is from the `cppman` repository, which is of course not frequently updated. Therefore, **if you do want the latest index database, you should execute `cppman -r` to build one yourself.**

## 🚀 Usage

## API

* `require('cppman').search()`: Search in all manuals. Use `telescope.nvim` if available, otherwise use `vim.ui.select()`.

* `require('cppman').open(keyword)`: find all entries contain keyword, if there is only one entry then directly open it. Otherwise launch a search pane and let you select one of the related entries.

* `require('cppman').fetch_index()`: use `curl` to download the latest index database.

## Command

* `:Cppman [keyword]`: calling with no argument will act like `search`, otherwise `open`.
