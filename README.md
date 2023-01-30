# orgmode-multi-key
Simple orgmode.nvim plugin to add a multipurpose key to do various action in org files. By default, the key used is the return key (`<cr>`).

Supported actions:
- open link
- open calendar to change date
- toggle headline status
- toggle checkboxes

## Installation with Packer.nvim

```lua
use {
  'andreadev-it/orgmode-multi-key',
  config = function()
    require('orgmode-multi-key').setup()
  end
}
```

## Options

There is only one option that you can pass to the `setup` function: the key to be used as a multipurpose mapping.

```lua
require('orgmode-multi-key').setup({
  key = "<leader>x"
})
```

By default, this key is `<cr>`, but it's customizable to any key or keychord you want.
