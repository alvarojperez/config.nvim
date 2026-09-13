--  See `:help vim.pack`, `:help vim.pack-examples` or the
--  excellent blog post from the creator of vim.pack and mini.nvim:
--  https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack
--
--  To inspect plugin state and pending updates, run
--    :lua vim.pack.update(nil, { offline = true })
--
--  To update plugins, run
--    :lua vim.pack.update()

local function run_build(name, cmd, cwd)
  local result = vim.system(cmd, { cwd = cwd }):wait()
  if result.code ~= 0 then
    local output = result.stderr ~= '' and result.stderr or result.stdout
    if output == '' then output = 'No output from build command.' end
    vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
  end
end

---Build steps keyed by plugin name, run after install or update.
---@type table<string, fun(ev: table)>
local builds = {
  ['telescope-fzf-native.nvim'] = function(ev)
    if vim.fn.executable 'make' == 1 then run_build(ev.data.spec.name, { 'make' }, ev.data.path) end
  end,

  ['LuaSnip'] = function(ev)
    if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then run_build(ev.data.spec.name, { 'make', 'install_jsregexp' }, ev.data.path) end
  end,

  ['nvim-treesitter'] = function(ev)
    if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
    vim.cmd 'TSUpdate'
  end,
}

vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('pack-build', { clear = true }),
  callback = function(ev)
    local kind = ev.data.kind
    if kind ~= 'install' and kind ~= 'update' then return end
    local build = builds[ev.data.spec.name]
    if build then build(ev) end
  end,
})
