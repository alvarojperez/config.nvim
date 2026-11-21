vim.pack.add { 'https://github.com/ember-theme/nvim' }

require('ember').setup {
  variant = 'ember-auto', -- "ember", "ember-soft", "ember-light", "ember-lighter", "ember-auto"
  styles = {
    comments = { italic = true },
    keywords = { bold = true },
    functions = {},
    types = { bold = true },
  },
  transparent = true, -- transparent editor background
  transparent_floats = nil, -- follows `transparent` by default; set explicitly to override
  dark_variant = 'ember', -- used by `ember-auto` when background = "dark"
  light_variant = 'ember-light', -- used by `ember-auto` when background = "light"
  on_colors = nil, -- function(palette) - modify palette before theme builds
  on_highlights = nil, -- function(highlights, theme) - modify highlight groups
}

vim.cmd.colorscheme 'ember'
