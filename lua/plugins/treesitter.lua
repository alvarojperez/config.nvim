vim.pack.add { { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' } }

-- Ensure basic parsers are installed
local parsers = {
  -- Baseline
  'bash',
  'c',
  'diff',
  'python',
  'lua',
  'luadoc',
  'query',
  'vim',
  'vimdoc',
  'markdown',
  'markdown_inline',
  -- Web
  'html',
  'css',
  'scss',
  'javascript',
  'typescript',
  'tsx',
  'jsdoc',
  'angular',
  -- Config and Data
  'json',
  'json5',
  'yaml',
  'toml',
  'sql',
  -- Git
  'gitcommit',
  'gitignore',
  'git_rebase',
  -- Others
  'dockerfile',
  'terraform',
  'regex',
  'ssh_config',
}
require('nvim-treesitter').install(parsers)

---@param buf integer
---@param language string
local function treesitter_try_attach(buf, language)
  -- Check if a parser exists and load it
  if not vim.treesitter.language.add(language) then return end

  -- Check if the buffer is valid (might not be after install completes)
  if not vim.api.nvim_buf_is_valid(buf) then return end

  -- Enable syntax highlighting and other treesitter features
  vim.treesitter.start(buf, language)

  -- Check if treesitter indentation is available for this language, and if so enable it
  -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
  local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

  -- Enable treesitter based indentation
  if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end

  -- 'foldexpr' and 'foldmethod' are window-local, so target the windows showing
  -- this buffer rather than whichever is current. The auto-install path calls
  -- this from a callback seconds after FileType, by which point the user may
  -- have moved elsewhere.
  -- For more info on folds see `:help folds`
  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.wo[win].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo[win].foldmethod = 'expr'
  end
end

local available_parsers = require('nvim-treesitter').get_available()
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('treesitter-attach', { clear = true }),
  callback = function(args)
    local buf, filetype = args.buf, args.match

    local language = vim.treesitter.language.get_lang(filetype)
    if not language then return end

    local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

    if vim.tbl_contains(installed_parsers, language) then
      -- Enable the parser if it is already installed
      treesitter_try_attach(buf, language)
    elseif vim.tbl_contains(available_parsers, language) then
      -- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
      require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
    else
      -- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
      treesitter_try_attach(buf, language)
    end
  end,
})
