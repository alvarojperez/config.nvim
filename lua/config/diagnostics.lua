vim.pack.add { 'https://github.com/rachartier/tiny-inline-diagnostic.nvim' }

--  See `:help vim.diagnostic.Opts`
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  -- Disable native diagnostigs in favor of tiny-inline-diagnostic.nvim
  virtual_text = false,
  virtual_lines = false,
}

require('tiny-inline-diagnostic').setup {
  options = {
    -- Display the source of diagnostics (e.g., "lua_ls", "pyright")
    show_source = {
      enabled = true, -- Enable showing source names
      if_many = false, -- Only show source if multiple sources exist for the same diagnostic
    },

    multilines = {
      enabled = true, -- Enable support for multiline diagnostic messages
    },

    -- Show all diagnostics on the current cursor line, not just those under the cursor
    show_all_diags_on_cursorline = true,
  },
}

-- Yank the diagnostic messages on the cursor line into `v:register`
local function yank_diagnostics()
  local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line '.' - 1 })
  if vim.tbl_isempty(diagnostics) then
    vim.notify('No diagnostics on this line', vim.log.levels.WARN)
    return
  end

  local messages = vim.tbl_map(function(d)
    -- Same `message [code]` shape `vim.diagnostic.open_float` defaults to
    return d.code and string.format('%s [%s]', d.message, d.code) or d.message
  end, diagnostics)
  local text = table.concat(messages, '\n')

  vim.fn.setreg(vim.v.register, text, text:find '\n' and 'l' or 'c')
end

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>td', '<cmd>TinyInlineDiag toggle<cr>', { desc = '[T]oggle [d]iagnostics' })
vim.keymap.set('n', 'yd', yank_diagnostics, { desc = '[Y]ank [d]iagnostic' })
