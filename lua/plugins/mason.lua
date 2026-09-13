-- Everything this config installs externally: language servers (whatever has a
-- config in after/lsp/, coming from config/servers.lua) plus the CLI tools conform shells out to.

vim.pack.add {
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
}

require('mason').setup {}
-- Translates lspconfig names to mason package names (lua_ls -> lua-language-server).
-- `automatic_enable = false` because plugins/lsp.lua enables servers explicitly.
require('mason-lspconfig').setup { automatic_enable = false }

require('mason-tool-installer').setup {
  ensure_installed = vim.list_extend(vim.deepcopy(require 'config.servers'), {
    -- Formatters invoked by conform; see plugins/formatting.lua.
    -- Not derivable from `formatters_by_ft` — conform calls ruff `ruff_format`.
    'oxfmt',
    'prettierd',
    'stylua',
  }),
}
