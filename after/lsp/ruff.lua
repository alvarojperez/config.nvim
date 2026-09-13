---@type vim.lsp.Config
return {
  on_init = function(client) client.server_capabilities.hoverProvider = false end,
}
