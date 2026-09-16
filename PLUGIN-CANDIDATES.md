# Plugin candidates

Working document — a shortlist to evaluate against the current config, not a
description of it. Delete once the decisions are made.

Each entry: what it does, why this config specifically wants it, the honest
alternatives, and what it costs.

---

## Tier 1 — clear gaps

### 1. Treesitter textobjects

**Repo:** `nvim-treesitter/nvim-treesitter-textobjects` (branch `main`, to match
the treesitter pin in `lua/plugins/treesitter.lua`)

**What it is.** A set of treesitter queries (`@function.outer`, `@class.inner`,
`@parameter.outer`, …) plus motions that use them.

**Why here.** `mini.ai` is already configured and covers a lot: `f` is a
function *call*, `a` is an argument, `t` is a tag. What is missing is the
function/class *definition*:

- no `af` / `if` — "change this whole method body"
- no `ac` / `ic` — "yank this class"
- no `]f` / `[f` — jump to the next function

For TypeScript and Angular components that is the textobject reached for most
often.

**How it should be wired.** Not as a second textobject system. `mini.ai`
accepts treesitter specs directly, so it goes inside the existing
`require('mini.ai').setup` call:

```lua
custom_textobjects = {
  f = require('mini.ai').gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },
  c = require('mini.ai').gen_spec.treesitter { a = '@class.outer', i = '@class.inner' },
}
```

Note this shadows `mini.ai`'s built-in `f` (function call). Decide whether
that trade is right, or bind the treesitter ones to different letters.

**Alternatives.** None really — this is the canonical source of these queries,
and `mini.ai` already knows how to consume it.

**Cost.** One plugin, queries only, no runtime setup. The `main` branch has a
different layout from `master`; check the README for the current API before
wiring.

- [ ] Decided:

---

### 2. Fast motion

Jump anywhere on screen in ~3 keystrokes. Currently there is nothing between
`f`/`t` (same line) and a fuzzy picker (whole project).

| | `folke/flash.nvim` | `ggandor/leap.nvim` | `nvim-mini/mini.jump2d` |
|---|---|---|---|
| Model | Enhances `f`/`t`/`/` in place, labels appear as you type | Dedicated `s`/`S` two-char jump | Dedicated label jump to word starts |
| Extras | Treesitter node selection (`S`), remote operations (`yr`) | Remote operations via companion plugin | Configurable spotters |
| Config surface | Largest | Small | Smallest |
| Fits this config | — | — | Already running 3 `mini.*` modules |

**Recommendation.** `mini.jump2d` unless the treesitter-node selection in
`flash.nvim` sounds appealing — that one feature (`S` to expand-select by AST
node, visually) has no equivalent in the other two and is genuinely useful in
nested JSX/HTML.

**Cost.** All three are small. `flash.nvim` overrides `f`/`t`/`/` by default,
which takes a few days to stop feeling strange.

- [ ] Decided:

---

### 3. Project-wide search and replace

**Repo:** `MagicDuck/grug-far.nvim`

**What it is.** A buffer where the top lines are the search, replace, and file
filter, and the rest is a live ripgrep result list. Edit the replace line, see
every match update, then apply to disk.

**Why here.** `<leader>sg` finds things across the project; nothing changes
them. Today a cross-file rename that the LSP cannot do (a string literal, a CSS
class, a config key) means dropping to a shell `sed`.

**Alternatives.** `nvim-spectre` is the older answer and still works, but is
less actively maintained and the UI is clunkier. `:cdo` over a quickfix list
from `live_grep` is the zero-plugin path and is worth knowing regardless —
`grug-far` is what makes it pleasant enough to actually reach for.

**Cost.** One plugin, one keymap, ripgrep already installed.

- [ ] Decided:

---

### 4. File marks

Pin 3–5 files and jump between them with a single keystroke each.

| | `ThePrimeagen/harpoon` (branch `harpoon2`) | `cbochs/grapple.nvim` |
|---|---|---|
| Model | A per-project ordered list, `<leader>1..4` | Same, plus scopes (git branch, cwd, LSP root) |
| Maturity | Very widely used | Newer, actively developed |
| Persistence | Per cwd | Per configurable scope |

**Why here.** Angular work means cycling `foo.component.ts`,
`foo.component.html`, `foo.service.ts`, `foo.spec.ts` all day. Fuzzy-finding a
file you visited 40 seconds ago is the slow path.

**Recommendation.** `grapple.nvim` if branch-scoped marks sound useful (marks
follow the feature you are on); `harpoon` if the simpler model is enough.

**Cost.** Small. Needs 4–5 keymaps to be worth anything — half-committing to
this plugin is worse than not having it.

- [ ] Decided:

---

## Tier 2 — high value, more taste-dependent

### 5. Diff viewing

**Repo:** `sindrets/diffview.nvim`

`gitsigns` handles per-hunk work well and is already fully mapped under
`<leader>h`. What is missing is the review view: "show me every file changed on
this branch, side by side, and let me walk them." `:DiffviewOpen main...HEAD`,
`:DiffviewFileHistory %`.

Complements gitsigns rather than replacing it.

**If a full git UI is also wanted:**

| | `NeogitOrg/neogit` | `tpope/vim-fugitive` |
|---|---|---|
| Model | magit-style status buffer, Lua | `:Git <anything>`, Vimscript |
| Integrates with diffview | Yes, natively | No (own diff UI) |
| Power ceiling | High | Higher |
| Learning curve | Gentle, discoverable | Steep, idiosyncratic, permanent |

**Cost.** `diffview` alone is low-cost and high-value. Adding neogit or
fugitive on top is a bigger commitment — worth deferring until `diffview` has
been used for a while.

- [ ] Decided:

---

### 6. Terminal

`lua/config/keymaps.lua` maps `<Esc><Esc>` to leave terminal mode, but nothing
opens a terminal in the first place.

| | `akinsho/toggleterm.nvim` | `folke/snacks.nvim` (terminal module) | Hand-rolled |
|---|---|---|---|
| Scope | Terminals only | ~20 modules, terminal is one | ~15 lines |
| Features | Float/split/tab, multiple named terminals, send-lines | Float terminal, toggle | Whatever is written |

**Note.** This is one of the few places where hand-rolling is genuinely
reasonable — `vim.fn.jobstart` with `term = true` in a float, plus a toggle, is
short and has no ongoing maintenance. Worth weighing against the project
convention of preferring dependencies: the deciding question is whether
multiple named terminals and send-region are wanted. If yes, take
`toggleterm`; if it is only ever one scratch shell, hand-rolling is fine.

**Do not** pull in all of `snacks.nvim` for the terminal alone.

- [ ] Decided:

---

### 7. Better diagnostic / quickfix list

`<leader>q` currently dumps diagnostics into the location list.

| | `folke/trouble.nvim` | `stevearc/quicker.nvim` |
|---|---|---|
| Approach | Replaces the list with its own tree UI | Improves the *built-in* quickfix window |
| Covers | Diagnostics, quickfix, loclist, LSP refs/defs, symbols | Quickfix and loclist |
| Keeps `[q` / `]q` working | Separate navigation | Yes, native |
| Weight | Larger | Smaller |

**Recommendation.** `quicker.nvim` fits this config's style better — it keeps
the native list (and the built-in `[q`/`]q` from 0.11) and adds inline context,
expandable results, and editable entries. Take `trouble` if a persistent
project-wide diagnostics tree is wanted.

- [ ] Decided:

---

### 8. Sessions

`undofile` is on, so undo history survives a restart — but window layout, open
buffers, and folds do not.

| | `folke/persistence.nvim` | `rmagatti/auto-session` | `nvim-mini/mini.sessions` |
|---|---|---|---|
| Size | ~100 LOC, does one thing | Larger, many hooks | Mid, mini ecosystem |
| Auto-restore | Opt-in via keymap | Automatic by cwd | Manual or auto |
| Git-branch aware | No | Yes | No |

**Recommendation.** `persistence.nvim` — right size for this config.
`<leader>Qs` to restore the session for the cwd.

**Note.** Needs `vim.o.sessionoptions` to be set sensibly (the default drops
folds and buffer-locals).

- [ ] Decided:

---

### 9. Debugging

**Repos:** `mfussenegger/nvim-dap` + `rcarriga/nvim-dap-ui` +
`nvim-neotest/nvim-nio` (a dap-ui dependency), plus one adapter per language.

**Adapters needed here:**

- TypeScript / Angular: `vscode-js-debug`, installed via Mason
  (`js-debug-adapter`), configured manually against `nvim-dap`. The old
  `mxsdev/nvim-dap-vscode-js` wrapper is effectively unmaintained — verify
  its status before depending on it; the manual adapter config is the safer
  path.
- Python: `mfussenegger/nvim-dap-python` + `debugpy` from Mason. This one is
  genuinely a two-line setup.

**Why here.** There is currently no debugger at all. For Angular this matters —
stepping through a change-detection cycle is not something `console.log`
replaces.

**Cost.** The highest-setup item on this list by a wide margin, and the
JS adapter config is fiddly. Worth deferring until there is a concrete bug
that justifies it — then doing it properly once.

- [ ] Decided:

---

## Tier 3 — small, cheap, pleasant

### 10. `nvim-mini/mini.splitjoin`

`gS` toggles an object, array, or parameter list between one line and many.
Constant use in TypeScript. Tiny, matches the existing `mini.*` stack.

- [ ] Decided:

### 11. `nvim-mini/mini.move`

`<M-h/j/k/l>` moves the current line or visual selection, re-indenting as it
goes. Only needed if the equivalent hand-rolled `J`/`K` visual maps are not
wanted — the plugin handles indentation and multi-line blocks more correctly
than the two-line version.

- [ ] Decided:

### 12. `stevearc/oil.nvim`

Edit a directory as a normal buffer: rename by editing text, delete with `dd`,
create by adding a line, `:w` to apply. Complements `neo-tree` (tree for
browsing and orientation, oil for bulk filesystem edits) rather than replacing
it. Also makes `-` a natural "go to parent directory" motion.

- [ ] Decided:

### 13. `MeanderingProgrammer/render-markdown.nvim`

In-buffer markdown rendering: headings, tables, code blocks, callouts. The
`markdown` and `markdown_inline` parsers are already installed and markdown is
already formatted via prettier — this makes it readable while editing.

- [ ] Decided:

### 14. Undo tree

`undofile` is on but there is no way to browse the tree. `mbbill/undotree`
(Vimscript, the standard) or `jiaoshijie/undotree` (Lua, lighter, fewer
features). Either way it is one keymap and almost no config.

- [ ] Decided:

### 15. `vuki656/package-info.nvim`

Inline virtual text in `package.json` showing installed vs. latest version,
with commands to change or delete a dependency. Requires `plenary` (already
installed).

**Caveat.** Check maintenance status before adopting — this one has been quiet.
Lower confidence than the rest of this list.

- [ ] Decided:

---

## Not a plugin, but decide it consciously

### Picker

`telescope.nvim` was inherited from kickstart rather than chosen. It is still
maintained and has by far the largest extension ecosystem, so staying is a
perfectly good answer — but it is worth being a decision.

| | `nvim-telescope/telescope.nvim` | `ibhagwan/fzf-lua` | `folke/snacks.nvim` (picker) |
|---|---|---|---|
| Sorter | Lua, or native fzf via the C extension | Native fzf binary | Lua, optimised |
| Speed on large repos | Good with `fzf-native` | Fastest | Fast |
| Extensions | Largest ecosystem | Built-in coverage is broad | Bundled with ~20 other modules |
| Git integration | Via extensions | Strong out of the box | Good |
| Cost to switch | — | Rewrite `picker.lua` | Pulls in a large plugin |

**In this config's favour:** `lua/plugins/picker.lua` is already written as the
single place that owns both the picker keymaps *and* the LSP navigation maps
(`grr`, `gri`, `grd`, `gO`, `gW`, `grt`). Switching means rewriting one file
and nothing else — which was the right structure to have chosen.

**Recommendation.** Stay on telescope unless large-repo `live_grep` latency is
actually being felt. If it is, `fzf-lua` is the direct swap. Do not adopt
`snacks.nvim` for the picker alone.

- [ ] Decided:

---

## Lazy loading

Not a plugin, but the other structural item worth a decision.

Everything currently loads eagerly — about 72ms of Lua at startup, of which
`picker` (~11ms) and `mason` (~11ms) are the largest. `vim.pack.add` supports
`{ load = false }`, which registers a plugin without `:packadd`-ing it, so it
can be loaded from a keymap or autocmd instead.

Best candidates:

- **mason** — nothing needs it until something is installed. The catch is that
  `mason-tool-installer`'s `ensure_installed` runs at startup; deferring mason
  means moving that behind a manual `:MasonToolsInstall`.
- **neo-tree** — purely on demand; `packadd` inside the `<leader>e` keymap.
- **telescope** — needs `builtin` to stop being an upvalue in the `LspAttach`
  callback; `require('telescope.builtin')` lazily inside each mapping instead.

**Honest assessment:** 72ms is not slow. Worth doing for the understanding of
`vim.pack`, not because startup hurts.

- [ ] Decided:
