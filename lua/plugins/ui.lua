vim.pack.add {
  'https://github.com/folke/which-key.nvim',
  'https://github.com/folke/todo-comments.nvim',
  'https://github.com/lukas-reineke/indent-blankline.nvim',
  'https://github.com/kevinhwang91/nvim-hlslens',
  'https://github.com/j-hui/fidget.nvim',
  'https://github.com/OXY2DEV/helpview.nvim',
}

require('which-key').setup {
  -- Delay between pressing a key and opening which-key (milliseconds)
  delay = 250,
  preset = 'modern',
  icons = { mappings = vim.g.have_nerd_font },
  -- Document existing key chains
  spec = {
    { '<leader>s', group = '[S]earch', icon = '', mode = { 'n', 'v' } },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>g', group = '[G]it', icon = { cat = 'filetype', name = 'git', color = 'orange' }, mode = { 'n', 'v' } }, -- Enable gitsigns recommended keymaps first
    { 'gr', group = 'LSP Actions', mode = { 'n' } },
  },
}

-- If a nerd font is available, load the icons module for pretty icons in various plugins.
if vim.g.have_nerd_font then
  vim.pack.add { 'https://github.com/nvim-mini/mini.icons' }
  require('mini.icons').setup()
  -- Used for backwards compatibility with plugins that require `nvim-web-devicons` (e.g. telescope.nvim)
  require('mini.icons').mock_nvim_web_devicons()
end

-- Highlight todo, notes, etc in comments
require('todo-comments').setup()

-- Indentation guides, including on blank lines
-- See `:help ibl`
require('ibl').setup {}

-- Show number eg [1/32] next to search result inline
require('hlslens').setup()

require('fidget').setup {}

require('helpview').setup()
