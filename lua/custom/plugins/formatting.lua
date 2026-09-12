-- ============================================================
-- FORMATTING
-- conform.nvim setup and keymap
-- ============================================================

vim.pack.add { 'https://github.com/stevearc/conform.nvim' }

local web_formatters = { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true }

-- Ruff ignores `.flake8` and its own defaults differ from what these projects
-- use, so only format where a project has actually opted into ruff. A bare
-- `pyproject.toml` is not enough, it has to carry a `[tool.ruff]` section.
---@param _ conform.JobFormatterConfig
---@param ctx conform.Context
---@return string|nil
local function ruff_root(_, ctx)
  return vim.fs.root(ctx.dirname, function(name, path)
    if name == 'ruff.toml' or name == '.ruff.toml' then return true end
    if name ~= 'pyproject.toml' then return false end
    local f = io.open(vim.fs.joinpath(path, name), 'r')
    if not f then return false end
    local content = f:read '*a'
    f:close()
    return content:find '%[tool%.ruff' ~= nil
  end)
end

require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    -- Disable autoformat on certain filetypes
    local enabled_filetypes = {
      'lua',
      'python',
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
      'css',
      'scss',
      'html',
      'htmlangular',
      'json',
      'jsonc',
      'yaml',
      'markdown',
    }
    if not vim.tbl_contains(enabled_filetypes, vim.bo[bufnr].filetype) then return end

    -- Disable with a global or buffer-local variable
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end

    return { timeout_ms = 500 }
  end,
  default_format_opts = {
    lsp_format = 'fallback', -- Use external formatters if configured below, otherwise use LSP formatting. Set to `false` to disable LSP formatting entirely.
  },
  -- You can also specify external formatters in here.
  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'ruff_organize_imports', 'ruff_format' },
    javascript = web_formatters,
    javascriptreact = web_formatters,
    typescript = web_formatters,
    typescriptreact = web_formatters,
    css = web_formatters,
    scss = web_formatters,
    html = web_formatters,
    htmlangular = web_formatters,
    json = web_formatters,
    jsonc = web_formatters,
    yaml = web_formatters,
    markdown = web_formatters,
  },
  formatters = {
    oxfmt = {
      require_cwd = true,
      cwd = require('conform.util').root_file {
        '.oxfmtrc.json',
        '.oxfmtrc.jsonc',
        'oxfmt.config.ts',
        'oxfmt.config.mts',
      },
    },
    ruff_format = {
      require_cwd = true,
      cwd = ruff_root,
    },
    ruff_organize_imports = {
      require_cwd = true,
      cwd = ruff_root,
    },
  },
}

vim.api.nvim_create_user_command('FormatDisable', function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = 'Disable autoformat-on-save',
  bang = true,
})
vim.api.nvim_create_user_command('FormatEnable', function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = 'Re-enable autoformat-on-save',
})

vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format { async = true } end, { desc = '[F]ormat buffer' })

vim.keymap.set('n', '<leader>tf', function()
  vim.b.disable_autoformat = not vim.b.disable_autoformat
  vim.notify('Autoformat ' .. (vim.b.disable_autoformat and 'OFF' or 'ON') .. ' (buffer)')
end, { desc = '[T]oggle auto[f]ormat (buffer)' })

vim.keymap.set('n', '<leader>tF', function()
  vim.g.disable_autoformat = not vim.g.disable_autoformat
  vim.notify('Autoformat ' .. (vim.g.disable_autoformat and 'OFF' or 'ON') .. ' (global)')
end, { desc = '[T]oggle auto[F]ormat (global)' })
