require 'config.options'
require 'config.filetypes'
require 'config.keymaps'
require 'config.autocmds'
require 'config.diagnostics'

-- Build hooks are autocommands, so they must be registered before the first
-- `vim.pack.add()` or they will not fire for installs and updates.
require 'config.pack'

require 'plugins.treesitter'
require 'plugins.mason'
require 'plugins.lsp'
require 'plugins.formatting'
require 'plugins.completion'
require 'plugins.picker'
require 'plugins.git'
require 'plugins.editor'
require 'plugins.autopairs'
require 'plugins.autotag'
require 'plugins.oil'
require 'plugins.neotree'
require 'plugins.ui'
require 'plugins.colorscheme'

-- After the colourscheme: modicator reads its mode colours out of lualine's
-- theme, and only fills in highlights that don't exist yet.
require 'plugins.statusline'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
