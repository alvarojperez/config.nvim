-- See `:help gitsigns`
-- Adds git related signs to the gutter, as well as utilities for managing changes
vim.pack.add {
  'https://github.com/kdheepak/lazygit.nvim',
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/dlyongemallo/diffview-plus.nvim',
}

vim.keymap.set('n', '<leader>gg', ':LazyGit<CR>', { desc = 'Lazy[g]it', silent = true })

local gitsigns = require 'gitsigns'
gitsigns.setup {
  signs = {
    add = { text = '+' }, ---@diagnostic disable-line: missing-fields
    change = { text = '~' }, ---@diagnostic disable-line: missing-fields
    delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
    topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
    changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
  },
  -- gitsigns.nvim's recommended keymaps:
  on_attach = function(bufnr)
    -- Navigation
    vim.keymap.set('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        gitsigns.nav_hunk 'next'
      end
    end, { desc = 'Jump to next git [c]hange', buf = bufnr })

    vim.keymap.set('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gitsigns.nav_hunk 'prev'
      end
    end, { desc = 'Jump to previous git [c]hange', buf = bufnr })

    -- Visual mode actions
    vim.keymap.set('v', '<leader>gs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git [s]tage hunk', buf = bufnr })
    vim.keymap.set('v', '<leader>gr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git [r]eset hunk', buf = bufnr })
    -- Normal mode actions
    vim.keymap.set('n', '<leader>gs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk', buf = bufnr })
    vim.keymap.set('n', '<leader>gr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk', buf = bufnr })
    vim.keymap.set('n', '<leader>gS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer', buf = bufnr })
    vim.keymap.set('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer', buf = bufnr })
    vim.keymap.set('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'git [p]review hunk', buf = bufnr })
    vim.keymap.set('n', '<leader>gi', gitsigns.preview_hunk_inline, { desc = 'git preview hunk [i]nline', buf = bufnr })
    vim.keymap.set('n', '<leader>gb', function() gitsigns.blame_line { full = true } end, { desc = 'git [b]lame line', buf = bufnr })
    vim.keymap.set('n', '<leader>gd', gitsigns.diffthis, { desc = 'git [d]iff against index', buf = bufnr })
    vim.keymap.set('n', '<leader>gD', function() gitsigns.diffthis '~' end, { desc = 'git [D]iff against last commit', buf = bufnr })
    vim.keymap.set('n', '<leader>gQ', function() gitsigns.setqflist 'all' end, { desc = 'git hunk [Q]uickfix list (all files in repo)', buf = bufnr })
    vim.keymap.set('n', '<leader>gq', gitsigns.setqflist, { desc = 'git hunk [q]uickfix list (all changes in this file)', buf = bufnr })
    -- Toggles
    vim.keymap.set('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line', buf = bufnr })
    vim.keymap.set('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = '[T]oggle git intra-line [w]ord diff', buf = bufnr })
    -- Text object
    vim.keymap.set({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = 'text object [i]nside [h]unk', buf = bufnr })
  end,
}

require('diffview').setup {
  enhanced_diff_hl = true,
  use_icons = true,
  view = {
    default = { layout = 'diff2_horizontal' },
    merge_tool = { layout = 'diff3_horizontal' },
  },
  file_panel = {
    listing_style = 'tree',
  },
  hooks = {}, -- See :h diffview-config-hooks
  keymaps = {}, -- See :h diffview-config-keymaps
}

-- Diff against a branch selected via Telescope
vim.keymap.set('n', '<leader>gdb', function()
  require('telescope.builtin').git_branches {
    attach_mappings = function(_, map)
      map({ 'n', 'i' }, '<CR>', function(prompt_bufnr)
        local selection = require('telescope.actions.state').get_selected_entry()
        require('telescope.actions').close(prompt_bufnr)
        vim.cmd('DiffviewOpen ' .. selection.value)
      end)
      return true
    end,
  }
end, { desc = 'Diffview branch' })

-- File history for a commit selected via Telescope
vim.keymap.set('n', '<leader>gdc', function()
  require('telescope.builtin').git_commits {
    attach_mappings = function(_, map)
      map({ 'n', 'i' }, '<CR>', function(prompt_bufnr)
        local selection = require('telescope.actions.state').get_selected_entry()
        require('telescope.actions').close(prompt_bufnr)
        vim.cmd('DiffviewOpen ' .. selection.value .. '^!')
      end)
      return true
    end,
  }
end, { desc = 'Diffview commit' })

-- Toggle diffview open/close
vim.keymap.set('n', '<leader>gdv', '<cmd>DiffviewToggle<cr>', { desc = 'Toggle Diffview' })

-- Diff working directory
vim.keymap.set('n', '<leader>gdo', '<cmd>DiffviewOpen<cr>', { desc = 'Diffview open' })
vim.keymap.set('n', '<leader>gdc', '<cmd>DiffviewClose<cr>', { desc = 'Diffview close' })

-- File history
vim.keymap.set('n', '<leader>gdh', '<cmd>DiffviewFileHistory %<cr>', { desc = 'File history (current file)' })
vim.keymap.set('n', '<leader>gdH', '<cmd>DiffviewFileHistory<cr>', { desc = 'File history (repo)' })

-- Visual mode: history for selection
vim.keymap.set('v', '<leader>gdh', "<Esc><cmd>'<,'>DiffviewFileHistory --follow<CR>", { desc = 'Range history' })

-- Single line history
vim.keymap.set('n', '<leader>gdl', '<cmd>.DiffviewFileHistory --follow<CR>', { desc = 'Line history' })

vim.keymap.set('n', '<leader>gdp', 'DiffviewOpen origin/HEAD...HEAD --imply-local', { desc = 'Diff against base branch (PR style)' })
