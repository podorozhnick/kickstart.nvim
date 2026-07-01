-- recolor: Interactive colorscheme adjustment.
-- Loaded at the end of init.lua (via `require 'custom.plugins'`), after the
-- catppuccin-latte colorscheme is set, so its recolor.json overrides apply.
vim.pack.add { 'https://github.com/podorozhnick/recolor.nvim' }
require('recolor').setup()
