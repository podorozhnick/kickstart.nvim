vim.opt.guicursor = 'n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor2/lCursor2,r-cr:hor20,o:hor50'

-- Insert-mode thin pipe cursor color (the `Cursor2`/`lCursor2` groups referenced above).
-- These groups aren't defined by default, so define them here and re-apply after any
-- colorscheme load so the color isn't wiped out.
local function set_cursor2()
  vim.api.nvim_set_hl(0, 'Cursor2', { bg = '#000000' })
  vim.api.nvim_set_hl(0, 'lCursor2', { bg = '#000000' })
end

vim.api.nvim_create_autocmd('ColorScheme', {
  desc = 'Set insert-mode pipe cursor color',
  callback = set_cursor2,
})

set_cursor2()
