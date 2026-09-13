-- Neovim detects `htmlangular` by scanning the first 40 lines for Angular
-- control flow, so templates that only use interpolation stay `html` and get
-- the html treesitter parser. Inside an Angular project the filename is
-- enough. Returning nil falls back to the built-in detection.
-- See `:help vim.filetype.add()`
vim.filetype.add {
  pattern = {
    ['.*%.component%.html'] = function(path, _)
      if vim.fs.root(path, { 'angular.json', 'nx.json' }) then return 'htmlangular' end
    end,
  },
}
