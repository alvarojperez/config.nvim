# Álvaro's Config

I use neovim btw

## Prerequisites

Plugins are managed with the built-in `vim.pack`, so there is no plugin manager
to bootstrap, but the following must be on your `$PATH`:

| Tool | Why |
| --- | --- |
| [Neovim](https://neovim.io) **0.12+** | `vim.pack`, `vim.lsp.enable`, `vim.lsp.document_color` and `winborder` are all 0.12 APIs. |
| `git` | `vim.pack` clones every plugin; gitsigns, diffview and lazygit need it too. |
| C compiler (`cc`/`clang`) + `make` | Compiles treesitter parsers and builds `telescope-fzf-native` (see below). |
| [`tree-sitter` CLI](https://github.com/tree-sitter/tree-sitter) (0.25+) | Required by the `main` branch of nvim-treesitter to install parsers. |
| `curl`, `tar`, `gzip`, `unzip` | Used by nvim-treesitter, mason and blink.cmp (Rust fuzzy matcher download). |
| [Node.js](https://nodejs.org) + `npm` | Mason installs most language servers and formatters as npm packages: `pyright`, `tsc` (TypeScript 7), `eslint`, `html`/`cssls`/`jsonls`, `yamlls`, `tailwindcss`, `angularls`, `emmet_language_server`, `oxlint`, `oxfmt`, `prettierd`. |
| [ripgrep](https://github.com/BurntSushi/ripgrep) (`rg`) | Telescope `live_grep` / `grep_string` (`<leader>sg`, `<leader>sw`, `<leader>s/`). |
| [lazygit](https://github.com/jesseduffield/lazygit) | `:LazyGit` / `<leader>gg`. |
| [delta](https://github.com/dandavison/delta) | `tiny-code-action.nvim` is configured with `backend = 'delta'` to preview code actions. |
| A [Nerd Font](https://www.nerdfonts.com) set as the terminal font | `vim.g.have_nerd_font = true`: icons in mini.icons, lualine, neo-tree, which-key, blink. The statusline's bubble separators need it too. |

On macOS with Homebrew:

```sh
xcode-select --install   # cc, make, git
brew install neovim tree-sitter-cli node ripgrep lazygit git-delta
brew install --cask font-jetbrains-mono-nerd-font   # or any Nerd Font
```

Everything else (language servers, `stylua`, `ruff`, `oxfmt`, `prettierd`, …) is
installed automatically by mason on first launch. Check `:Mason` and
`:checkhealth` afterwards.

## Optional extras

Not required, but they make things nicer:

| Tool | What it improves |
| --- | --- |
| [fd](https://github.com/sharkdp/fd) | Telescope `find_files` uses `fd` when available instead of `rg`/`find`. Faster, and respects `.gitignore`. |
| `make` (again) | `telescope-fzf-native` is only installed when `make` exists. It replaces Telescope's Lua sorter with a compiled fzf sorter: much faster on large repos, and supports fzf syntax (`'exact`, `^prefix`, `suffix$`, `!negate`). |
| Python 3 | Lets mason install Python-based tools if you add any; `ruff` itself ships as a binary. |
| `typescript` 7+ in the project | The `tsc` server prefers the project's `node_modules/.bin/tsc` if it supports `--lsp`. Same for local `oxlint` / `tailwindcss` installs. |
| A clipboard provider | `clipboard=unnamedplus` uses `pbcopy`/`pbpaste` on macOS (built in). On Linux install `wl-clipboard` or `xclip`. |
