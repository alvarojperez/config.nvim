vim.pack.add { 'https://github.com/stevearc/oil.nvim' }

local always_hidden = {
  '.git',
}

require('oil').setup {
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

vim.keymap.set('n', '<leader>e', ':Oil --float<cr>', { silent = true })
