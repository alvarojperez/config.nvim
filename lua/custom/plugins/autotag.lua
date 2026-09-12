-- ============================================================
-- AUTOTAG
-- Close and rename HTML/JSX tags using treesitter
-- ============================================================

vim.pack.add { 'https://github.com/windwp/nvim-ts-autotag' }

-- Calling setup() explicitly keeps it off the deprecated
-- `nvim-treesitter.configs` path, which the main branch no longer provides.
require('nvim-ts-autotag').setup {
  opts = {
    enable_rename = true,
    enable_close = true,
    enable_close_on_slash = true,
  },
}
