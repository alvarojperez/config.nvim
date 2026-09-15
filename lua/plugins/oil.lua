vim.pack.add {
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/malewicz1337/oil-git.nvim',
}

local always_hidden = {
  '..',
  '.git',
  'node_modules',
  '.next',
}

local oil = require 'oil'
oil.setup {
  skip_confirm_for_simple_edits = true,
  view_options = {
    show_hidden = true,
    is_always_hidden = function(name, _) return vim.tbl_contains(always_hidden, name) end,
  },
  watch_for_changes = true,
  win_options = {
    signcolumn = 'yes:2',
  },
}

require('oil-git').setup {
  symbol_position = 'signcolumn',
}

vim.keymap.set('n', '<leader>e', function()
  oil.toggle_float(nil, {
    preview = {
      vertical = true,
    },
  })
end, {
  desc = 'Explorer (oil)',
})
