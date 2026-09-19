vim.pack.add {
  'https://github.com/NMAC427/guess-indent.nvim',
  'https://github.com/nvim-mini/mini.ai',
  'https://github.com/nvim-mini/mini.splitjoin',
  'https://github.com/nvim-mini/mini.surround',
  'https://github.com/abecodes/tabout.nvim',
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
}
require('guess-indent').setup {}

-- Better Around/Inside textobjects
--  - va)  - [V]isually select [A]round [)]paren
--  - yiiq - [Y]ank [I]nside [I]+1 [Q]uote
--  - ci'  - [C]hange [I]nside [']quote
require('mini.ai').setup {
  -- NOTE: Avoid conflicts with the built-in incremental selection mappings on Neovim>=0.12 (see `:help treesitter-incremental-selection`)
  mappings = {
    around_next = 'aa',
    inside_next = 'ii',
  },
  n_lines = 500,
}

require('mini.splitjoin').setup()

-- Add/delete/replace surroundings (brackets, quotes, etc.)
-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
require('mini.surround').setup()

-- Jump out of (), '' and similar blocks with <Tab>
require('tabout').setup {}

require('render-markdown').setup {
  completions = { lsp = { enabled = true } },
}
vim.keymap.set('n', '<leader>tm', ':RenderMarkdown toggle<CR>', { desc = '[T]oggle [M]arkdown Rendering', silent = true })
