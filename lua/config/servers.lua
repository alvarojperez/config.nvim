-- Every language server this config enables. The registry is `after/lsp/`:
-- one file per server, named after its nvim-lspconfig entry. An empty
-- `return {}` is enough to enable a server with lspconfig's defaults.
local dir = vim.fs.joinpath(vim.fn.stdpath 'config', 'after', 'lsp')

local servers = {}
for name, type in vim.fs.dir(dir) do
  if type == 'file' and name:match '%.lua$' then table.insert(servers, name:sub(1, -5)) end
end
table.sort(servers)

return servers
