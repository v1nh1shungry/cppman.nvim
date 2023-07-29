# cppman.nvim

Search and view the [cppreference](https://en.cppreference.com/) manuals on the fly, in your favorite editor!

**NOTE**: Currently only **Linux** is supported.

# Showcase

![](https://user-images.githubusercontent.com/98312435/256980587-be86148a-1e35-4b2a-85d0-f905782746ab.gif)

# Features

* View the manuals right inside the neovim.

* Search in all manuals on the fly. What you can expect from [a vscode extension](https://github.com/Guyutongxue/VSC_CppReference) or [a browser extension](https://github.com/huhu/cpp-search-extension) is now available in neovim!

* `K` keymap support. In the manual you can press `K` and jump to the manual for `<cword>`.

# Installation

1. neovim >= 0.9. I haven't had a chance to get a accurate version. I do disable `statuscolumn` in the plugin and don't check the version, and `statuscolumn` is available in a recent version.

1. Make sure `curl` is available in `$PATH`. Note that `curl` is used to download [the index database](https://raw.githubusercontent.com/aitjcize/cppman/master/cppman/lib/index.db). You can manually download it (if you have already installed `cppman` you can get it from `<cppman-install-directory>/lib/index.db`) and place it in `$HOME/.local/share/nvim/cppman.db` or other directory with [configuration](#Configuration). In this case `curl` is unnecessary.

2. Make sure `cppman` is available in `$PATH`.

3. [lazy.nvim](https://github.com/folke/lazy.nvim)
   ```lua
   {
     'v1nh1shungry/cppman.nvim',
     dependencies = {
       'kkharji/sqlite.lua', -- mandatory, used to query the index database
       'nvim-telescope/telescope.nvim', -- optional, if absent `vim.ui.select` will be used
     },
     opts = {},
   }
   ```

# Configuration

```lua
-- default
require('cppman').setup {
  -- where the manual window displays
  -- can be 'split', 'vsplit' or 'tab'
  position = 'split',
  -- where the index database stores
  index_db_path = vim.fn.stdpath('data') .. '/cppman.db',
}
```

**NOTE**: even if you set `index_db_path`, `$XDG_CACHE_HOME/cppman/index.db` will be used if it exists, because this one is more likely to be the latest. When you run `cppman -r`, `cppman` will rebuild the index database and store it in `$XDG_CACHE_HOME/cppman/index.db`. The index database this plugin downloads is from the `cppman` repository, which is of course not frequently updated. Therefore, **if you do want the latest index database, you should execute `cppman -r` to build one yourself.**

# Usage

* `require('cppman').search()`: Search in all manuals. Use `telescope.nvim` if available, otherwise use `vim.ui.select()`.

* `require('cppman').open(keyword)`: find all entries contain keyword, if there is only one entry then directly open it. Otherwise launch a search pane and let you select one of the related entries.

* `require('cppman').fetch_index()`: use `curl` to download the latest index database.
