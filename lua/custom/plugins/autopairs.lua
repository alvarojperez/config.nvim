-- ============================================================
-- AUTOPAIRS
-- Insert matching brackets and quotes while typing
-- ============================================================

vim.pack.add { 'https://github.com/windwp/nvim-autopairs' }

require('nvim-autopairs').setup {
  -- Consult treesitter before pairing. Requires treesitter highlighting to be
  -- active in the buffer, which `treesitter.lua` starts on FileType.
  check_ts = true,
  -- Nodes to skip pairing inside, keyed by filetype rather than by treesitter
  -- language. Upstream only ships `lua` and `javascript`.
  ts_config = {
    lua = { 'string', 'source', 'string_content' },
    javascript = { 'string', 'template_string' },
    javascriptreact = { 'string', 'template_string' },
    typescript = { 'string', 'template_string' },
    typescriptreact = { 'string', 'template_string' },
  },
  -- <M-e> wraps the text ahead of the cursor in a pair of your choosing.
  fast_wrap = {},
}
