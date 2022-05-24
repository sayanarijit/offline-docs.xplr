# Offline Docs

This plugin makes it easy to fetch the appropriate version of xplr docs and browse offline.

## Usage

- Type <kbd>:</kbd> <kbd>?</kbd> to browse the offline docs.
- Delete the docs directory and try the same keys to re-fetch the docs.

NOTE: The `version` defined in your `~/.config/xplr/init.lua` should be correct.

## Requirements

- curl
- tar

## Installation

### Install using xpm.xplr

```lua
require("xpm").setup({
  -- ...
  { name = "sayanarijit/offline-docs.xplr" },
  -- ...
})
```

### Install manually

- Add the following line in `~/.config/xplr/init.lua`

  ```lua
  local home = os.getenv("HOME")
  package.path = home
    .. "/.config/xplr/plugins/?/src/init.lua;"
    .. home
    .. "/.config/xplr/plugins/?.lua;"
    .. package.path
  ```

- Clone the plugin

  ```bash
  mkdir -p ~/.config/xplr/plugins

  git clone https://github.com/sayanarijit/offline-docs.xplr ~/.config/xplr/plugins/offline-docs
  ```

- Require the module in `~/.config/xplr/init.lua`

  ```lua
  require("offline-docs").setup()

  -- Or

  require("offline-docs").setup{
    mode = "action",
    key = "?",
    local_path = os.getenv("HOME") .. "/.local/share/xplr/doc"
  }
  ```
