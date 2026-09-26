vim.pack.add {
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/mawkler/modicator.nvim',
}

-- Colours for the custom components below are looked up on every draw rather
-- than captured once, so `:Catppuccin latte` and friends take effect without a
-- restart, the same way lualine's own `theme = 'auto'` does.
local function palette() return require('catppuccin.palettes').get_palette() end

-- Lualine only repaints on a timer, which is too slow to
-- notice, so nudge it when recording starts and stops.
local macro = {
  function() return ' REC @' .. vim.fn.reg_recording() end,
  cond = function() return vim.fn.reg_recording() ~= '' end,
  color = function()
    local colors = palette()
    return { fg = colors.base, bg = colors.red, gui = 'bold' }
  end,
}
vim.api.nvim_create_autocmd({ 'RecordingEnter', 'RecordingLeave' }, {
  group = vim.api.nvim_create_augroup('lualine-macro-recording', { clear = true }),
  -- On RecordingLeave `reg_recording()` is still set, so refresh on the next tick.
  callback = function()
    vim.schedule(function() require('lualine').refresh { place = { 'statusline' } } end)
  end,
})

local autoformat_off = {
  function() return ' fmt' end,
  cond = function() return vim.b.disable_autoformat or vim.g.disable_autoformat end,
  color = function() return { fg = palette().peach } end,
}

require('lualine').setup {
  options = {
    theme = 'auto',
    -- Bubbles: each run of coloured sections ends in a half circle, so the
    -- statusline reads as pills floating on the (transparent) background
    -- rather than as one solid bar. See `lualine.nvim/examples/bubbles.lua`.
    component_separators = '',
    section_separators = { left = '', right = '' },
    -- One statusline for the whole window layout instead of one per split.
    globalstatus = true,
  },
  sections = {
    lualine_a = {
      {
        'mode',
        -- Lualine reports the one-command normal mode of insert `<C-o>` as plain
        -- NORMAL, so name the mode it returns to the way Vim's own showmode does.
        fmt = function(name)
          local pending = ({ niI = '(INSERT)', niR = '(REPLACE)', niV = '(V-REPLACE)' })[vim.api.nvim_get_mode().mode]
          return pending or name
        end,
        separator = { left = '', right = '' },
        padding = 0,
      },
    },
    lualine_b = {
      {
        'branch',
        -- Ticket-style branch names would otherwise push everything else
        -- around, so keep the start and mark where it was cut.
        fmt = function(name)
          if vim.fn.strcharlen(name) <= 20 then return name end
          return vim.fn.strcharpart(name, 0, 19) .. '…'
        end,
      },
      {
        'diff',
        -- Read the counts gitsigns already computed instead of shelling out to
        -- git. Its dict calls modified lines `changed`, which is not the key
        -- lualine reads, so they have to be mapped across.
        source = function()
          local gitsigns = vim.b.gitsigns_status_dict
          if gitsigns then return { added = gitsigns.added, modified = gitsigns.changed, removed = gitsigns.removed } end
        end,
      },
    },
    lualine_c = {
      {
        'filetype',
        icon_only = true,
        padding = { left = 1, right = 0 },
      },
      {
        'filename',
        path = 1,
        -- Columns reserved for the rest of the statusline. Parent directories
        -- collapse to initials (l/p/statusline.lua) before Vim starts cutting
        -- characters off the name itself. Raise it if a path still gets cut.
        shorting_target = 45,
        symbols = { modified = '●', readonly = '', unnamed = '[No Name]', newfile = '[New]' },
      },
    },
    lualine_x = { 'diagnostics' },
    lualine_y = {
      macro,
      autoformat_off,
      -- fidget reports the progress detail, so drop the trailing done marker
      -- and keep this to "which servers are attached, is one busy".
      { 'lsp_status', symbols = { done = '' } },
    },
    lualine_z = { {
      'location',
      separator = { left = '', right = '' },
      padding = 0,
    } },
  },
  extensions = { 'neo-tree', 'oil', 'mason', 'quickfix', 'man' },
}

-- Colour the cursor's line number by mode. It copies the colours out of
-- lualine's mode section, so it has to be set up after both the colourscheme
-- and `lualine.setup()`: it only fills in highlights that don't exist yet, and an early setup would lock in its own fallbacks.
require('modicator').setup()
