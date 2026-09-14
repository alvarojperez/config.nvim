vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

require('neo-tree').setup {
  close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
  sort_case_insensitive = true, -- Matches the case-insensitive filesystem on macOS
  filesystem = {
    -- Reveal the current file, both when opening the tree and when switching
    -- buffers while it is open. Files outside the tree root are skipped
    -- silently, so the cwd is never changed and nothing is prompted.
    follow_current_file = { enabled = true, leave_dirs_open = true },
    -- OS-level file watchers, so changes made outside Neovim (git checkout,
    -- package installs) show up without a manual refresh.
    use_libuv_file_watcher = true,
    filtered_items = {
      hide_dotfiles = false, -- This config is itself a dotfiles repo
      hide_gitignored = true,
      -- `always_show*` wins over both gitignore and other ignore files.
      always_show_by_pattern = { '.env*' },
    },
  },
}

vim.keymap.set(
  'n',
  '<leader>E',
  function()
    require('neo-tree.command').execute {
      action = 'focus',
      source = 'filesystem',
      position = 'left',
      toggle = true,
    }
  end,
  { desc = 'Explorer NeoTree (reveal or cwd)' }
)
