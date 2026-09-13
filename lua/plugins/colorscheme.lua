vim.pack.add { { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' } }

require('catppuccin').setup {
  flavour = 'mocha',
  auto_integrations = true,
  transparent_background = true,
}

vim.cmd.colorscheme 'catppuccin-nvim'
