# Nvim config

A plain Lua Neovim config that runs on NixOS, other Linux distros (including
WSL), and natively on Windows.

- **Plugins** are declared as [lazy.nvim](https://github.com/folke/lazy.nvim)
  specs in `lua/plugins/`.
- **Plugin versions** are pinned in `lazy-lock.json`, the single source of
  truth on every platform. When it changes, installed plugins are moved to the
  new commits automatically on the next start (see `lua/arlo/lockfile.lua`).
- **On Nix**, `flake.nix` wraps Neovim with this config and puts the tools it
  needs (git, rg, fd, tree-sitter, a C compiler, …) on PATH.
- **Elsewhere**, LSP servers can be installed with `:Mason`. On Nix, Mason
  is disabled and servers come from each project's direnv shell as before.

Needs Neovim 0.12 (what the flake's nixpkgs ships). 0.11 may work but is
untested.

## Layout

```
init.lua                 entry point
lua/config/
  options.lua            vim options
  keymaps.lua            mappings that don't belong to a plugin
  autocmds.lua
  lazy.lua               bootstraps and sets up lazy.nvim
  lockfile.lua           keeps plugins in sync with lazy-lock.json
  platform.lua           is_windows / is_nix / is_vscode
  health.lua             :checkhealth config
lua/plugins/*.lua        plugin specs by area, with their keymaps
after/lsp/<server>.lua   per-server overrides on top of nvim-lspconfig
lazy-lock.json           pinned plugin commits
```

Run `:checkhealth config` to see which external tools are missing on the
current machine.

## Install

### Nix (NixOS, or Nix on another distro or WSL)

```sh
nix run github:arlohb/nvim
# or install it
nix profile install github:arlohb/nvim
```

The first start clones the plugins at the commits in `lazy-lock.json`. A
newer build of the flake with a different lockfile restores them to the new
commits.

### Other Linux / macOS

Install `neovim git ripgrep fd tree-sitter-cli` and a C compiler, then:

```sh
git clone https://github.com/arlohb/nvim ~/.config/nvim
nvim
```

### Windows

Install the tools (PowerShell):

```powershell
winget install Neovim.Neovim Git.Git BurntSushi.ripgrep.MSVC sharkdp.fd Microsoft.PowerShell LLVM.LLVM tree-sitter.tree-sitter-cli
```

Then:

```powershell
git clone https://github.com/arlohb/nvim $env:LOCALAPPDATA\nvim
nvim
```

The terminal (`<leader>ot`) uses `pwsh`. Icons need a Nerd Font in your
terminal. Inline images (snacks.nvim) need a terminal with the kitty graphics
protocol, such as WezTerm.

### VSCode (vscode-neovim)

Point vscode-neovim at the same `nvim`. Only plugins marked `vscode = true`
load (editing motions, which-key mappings).

## Updating plugins

From a normal checkout (for example the `~/.config/nvim` clone, or
`NVIM_APPNAME`):

1. `:Lazy update` (or `:Lazy check` to preview). `<leader>oL` opens the
   plugin manager, and `<leader>om` opens Mason where it's used.
2. Try it out, then commit the `lazy-lock.json` diff.
3. On other machines, `git pull` (or rebuild the flake). The next start
   restores plugins to the new commits. You can also run `:Lazy restore`
   manually.

lazy.nvim itself works on a copy of the lockfile in Neovim's state
directory, so plugins left over from another config can't overwrite the
repo's pins. After `:Lazy update` or `:Lazy sync` the new pins are copied
into the repo's `lazy-lock.json`. Under the Nix wrapper the config is
read-only, so updates there only last until the next start; run them from a
checkout instead.

## Development

`nix develop` (or direnv) gives a shell with `lua-language-server` and
`stylua` (formatting config in `.stylua.toml`).
`nix flake check` checks that the Lua parses and that `lazy-lock.json` is
valid.
