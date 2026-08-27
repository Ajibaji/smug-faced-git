# AGENTS.md

This is a **dotfiles configuration repository** that manages terminal and development environment configurations across macOS, Linux, and Windows using [Dotbot](https://github.com/anishathalye/dotbot).

## Quick Start

```bash
# Clone and run full setup (interactive menu)
./go.sh

# Or run directly:
./dotbot-run.sh           # Full setup (symlinks + OS-specific configs)
./dotbot-run.sh symlink   # Symlinks only (no package installation)
```

## Repository Structure

```
.
├── go.sh / go.ps1           # Interactive setup menu (macOS/Linux / Windows)
├── dotbot-run.sh            # Main entry point - runs Dotbot with configs
├── dotbot-run.ps1           # Windows entry point
├── base.conf.yaml           # Symlink definitions (cross-platform)
├── win.conf.yaml            # Windows-specific config
├── run-macos.sh             # macOS-specific setup (Homebrew, defaults)
├── run-linux.sh             # Linux-specific setup (apt packages, toolchains)
├── run-common.sh            # Cross-platform setup (pyenv, eget, fnm, bun)
├── post-run.sh              # Post-install tasks (bun globals, dotnet tools, az cli)
├── .hushlogin               # Suppress macOS login banner
├── k8s-plugins.txt          # kubectl plugins list (krew)
├── README.md                # Repository readme
├── schema-ado-pipelines-custom.json  # Azure DevOps pipelines schema
├── user-dirs.dirs           # XDG user directories (Linux)
├── user-dirs.locale         # XDG locale setting (Linux)
│
├── dotbot/                  # Git submodule - Dotbot core
│
└── <app>/                   # Per-application config directories
    └── config files...
```

## Key Configuration Directories

| Directory | Purpose |
|-----------|---------|
| `nvim/` | Neovim config (Lua, Lazy.nvim plugin manager) |
| `zsh/` | Zsh shell config (`.zshrc`, `.zprofile`, `.zshenv`) |
| `bash/` | Bash shell config (`.bashrc`, `.bash_profile`) |
| `shell/` | Shared shell config (env vars, aliases, functions, theme) |
| `aerospace/` | AeroSpace tiling window manager (macOS) |
| `amethyst/` | Amethyst tiling window manager (macOS) |
| `kitty/` | Kitty terminal config |
| `ghostty/` | Ghostty terminal config |
| `lazygit/` | LazyGit config (with light/dark themes) |
| `git-config/` | Git global config (`.gitconfig`, `.gitignore_global`) |
| `brew/` | Homebrew Brewfile (macOS packages) |
| `starship/` | Starship prompt config |
| `yazi/` | Yazi file manager config |
| `tmux/` | Tmux terminal multiplexer config |
| `delta/` | Delta diff viewer config |
| `atuin/` | Atuin shell history config |
| `helix/` | Helix editor config |
| `zed/` | Zed editor config |
| `nushell/` | Nushell config |
| `karabiner/` | Karabiner-Elements keyboard remapping (macOS) |
| `keyboard/` | Custom keyboard layout (`.bundle` file) |
| `sketchybar/` | Sketchybar status bar (macOS) |
| `lsd/` | LSD (LSDeluxe) file listing config |
| `bat/` | Bat (cat replacement) config |
| `raycast/` | Raycast launcher config (macOS) |
| `gram/` | Gram editor config |
| `neovide/` | Neovide GUI config |
| `powershell/` | PowerShell config |
| `pi/` | Pi coding agent settings (`settings.json`) |
| `herdr/` | Herdr terminal multiplexer config |
| `eget/` | Eget binary manager (custom fork, built from source) |
| `ble/` | Bash Line Editor config (`.blerc`) |
| `tflint/` | TFLint Terraform linter config |
| `neofetch/` | Neofetch system info config |
| `spotifyd/` | Spotifyd daemon config |
| `MacOS/` | macOS scripts (theme toggle, window resize, AppleScripts) |
| `kitty_pi_markdown/` | Kitty terminal pi markdown renderer |
| `winget/` | Windows Package Manager config |

## How Dotbot Works

1. **`base.conf.yaml`** defines symlinks from `~/.config/<app>` → repository directories and individual file mappings
2. **`run-macos.sh`** installs Homebrew, runs `Brewfile`, sets macOS defaults, symlinks GNU coreutils
3. **`run-linux.sh`** installs apt packages, pyenv, rustup, go, dotnet, and JetBrains Mono font
4. **`run-common.sh`** clones private repo, installs pyenv versions, builds eget, sets up fnm/node, installs bun
5. **`post-run.sh`** installs bun globals, pip packages, az cli, dotnet tools, shell completions

Symlinks are created with `force: true` and `relink: true`, meaning they will overwrite existing files.

### Notable Symlink Mappings

Beyond `~/.config/<app>` directories, these individual files are linked:

- `~/.aerospace.toml` → `aerospace/.aerospace.toml`
- `~/.bashrc` → `bash/.bashrc`
- `~/.bash_profile` → `bash/.bash_profile`
- `~/.blerc` → `ble/.blerc`
- `~/.eget.toml` → `eget/.eget.toml`
- `~/.gitconfig` → `git-config/.gitconfig`
- `~/.gitignore_global` → `git-config/.gitignore_global`
- `~/.hushlogin` → `./.hushlogin`
- `~/.pi/agent/settings.json` → `pi/settings.json`
- `~/.tflint.hcl` → `tflint/.tflint.hcl`
- `~/.tmux.conf` → `tmux/.tmux.conf`
- `~/.zprofile` → `zsh/.zprofile`
- `~/.zshenv` → `zsh/.zshenv`
- `~/.zshrc` → `zsh/.zshrc`

## Shell Configuration

The shell setup uses a layered approach:

```
zsh/.zshenv       → Loaded first (every shell, sets colour vars)
zsh/.zprofile     → Login shell setup
zsh/.zshrc        → Interactive shell (sources .zshroot)
zsh/.zshroot      → Common interactive config
shell/env.sh      → Environment variables (PATH, tool configs, OS detection)
shell/salad-source.sh → Sourced by rc files (imports aliases, theme, functions, secrets)
shell/lib/aliases.sh    → Shell aliases
shell/lib/functions.sh  → Shell functions
shell/lib/theme.sh      → Theme switching logic
shell/lib/colours.sh    → Colour definitions
shell/lib/env_mac.sh    → macOS-specific env vars
shell/lib/env_colours.sh → Colour-related env vars
```

### Key Environment Variables

- `EDITOR=nvim`
- `CURRENT_THEME` - Controls light/dark theme switching (used by lazygit, delta, nvim)
- `XDG_CONFIG_HOME=$HOME/.config`
- `OS` - Detected from `/etc/os-release` or set to `MacOS`
- `MANPAGER` - Uses `bat` for man page rendering

### Notable Aliases

```bash
v()            # function wrapping nvim (re-reads theme on exit)
vim='v'        # Neovim via function
lg='lazygit'   # LazyGit
kk='kubectl'   # Kubernetes
tt='toggle-theme'  # Theme switcher
gst='git status'
gco='git checkout'
cat='bat -pp'  # Bat as cat replacement
cls='clear -x' # Clear screen
git='git --config-env=delta.features=CURRENT_THEME'  # Theme-aware git diffs
```

On macOS, GNU coreutils are symlinked to `/usr/local/bin/` to replace BSD versions.

### Private Configuration

The repo references a private companion repo (`seeshellontheseasaw`) that is cloned to `~/seeshellontheseasaw` and sourced via `shell/salad-source.sh` for secrets/private config.

## Neovim Configuration

Located in `nvim/`, uses **Lazy.nvim** as the plugin manager.

```
nvim/
├── init.lua                  # Entry point
└── lua/
    ├── config/               # Core settings
    │   ├── init.lua          # Config module init
    │   ├── options.lua       # Vim options
    │   ├── keymaps.lua       # Key bindings
    │   ├── autocommands.lua  # Auto commands
    │   ├── constants.lua     # Shared constants
    │   ├── neovide.lua       # Neovide GUI settings
    │   └── fvim.lua          # FVim GUI settings
    ├── lazy/                 # Lazy.nvim setup
    ├── plugins/              # Plugin configs by category
    │   ├── flow/             # Workflow (autopairs, copilot, git, etc.)
    │   ├── lsp/              # LSP, completion, treesitter, formatting
    │   └── visual/           # UI (theme, statusbar, notifications)
    └── utils/                # Utility functions
```

Theme is controlled by `CURRENT_THEME` env var (values: `DARK` or `LIGHT`).

## Git Configuration

- Uses **delta** for diffs with side-by-side view
- Theme-aware diff colors via `git --config-env=delta.features=CURRENT_THEME` alias
- Global gitignore at `git-config/.gitignore_global`

## Submodules

The repo includes this Git submodule:

- `dotbot/` - Core Dotbot framework (v1.19.2+)

To update submodules:
```bash
git submodule update --init --recursive
```

## Platform-Specific Notes

### macOS

- Uses **Homebrew** for package management (`brew/Brewfile` - 104 entries)
- **AeroSpace** tiling window manager with vim-like keybindings
- **Sketchybar** status bar with borders (FelixKratz/borders)
- **Karabiner-Elements** for keyboard remapping
- **Raycast** launcher
- **Gram** as default text editor for Finder
- Extensive `defaults write` commands for system preferences
- GNU coreutils symlinked to `/usr/local/bin/` to replace BSD versions
- Notable casks: Ghostty, Neovide, Aerospace, Raycast, Visual Studio Code, Spotify

### Linux

- Uses **apt** for package management (build-essential, dev libraries, tools)
- Installs from `run-linux.sh`: pyenv, cargo/rust, go, dotnet (.NET 8.0 + 10.0), JetBrains Mono Nerd Font
- No separate NixOS script exists; `dotbot-run.sh` exits early for NixOS with a message

### Windows

- Uses `go.ps1` / `dotbot-run.ps1` for setup
- `win.conf.yaml` for Windows-specific configuration
- `winget/` directory for Windows Package Manager config
- PowerShell configuration in `powershell/`

### WSL

- PATH is cleaned of `/mnt/` entries during Linux setup

## Adding New Configurations

1. Create a directory for the application: `mkdir <app>/`
2. Add config files to the directory
3. Add symlink entry to `base.conf.yaml`:
   ```yaml
   - link:
       ~/.config/<app>: <app>
   ```
4. Run `./dotbot-run.sh symlink` to create the symlink

## Common Tasks

### Add a new Homebrew package (macOS)

Edit `brew/Brewfile`:
```ruby
brew "package-name"
# or
cask "app-name"
```

### Modify shell aliases

Edit `shell/lib/aliases.sh`

### Add shell environment variables

Edit `shell/env.sh`

### Add shell functions

Edit `shell/lib/functions.sh`

### Add a new tool via eget

Edit `eget/.eget.toml` (binary manager config at `~/.eget.toml`)

## Gotchas

1. **Submodules must be initialized** before running Dotbot - `dotbot-run.sh` handles this automatically
2. **Symlinks are forcefully overwritten** - existing files at target paths will be replaced
3. **macOS coreutils** are symlinked to `/usr/local/bin/` which may affect scripts expecting BSD behavior
4. **Theme switching** requires `CURRENT_THEME` env var to be set before launching apps
5. **Neovim plugins** are managed by Lazy.nvim, not system packages
6. **git stash** is automatically used during `dotbot-run.sh` if there are uncommitted changes
7. **NixOS** is detected via `$OS` and `dotbot-run.sh` exits early with a message (no NixOS-specific scripts)
8. **Eget** is built from a bundled source fork (not installed via package manager)
9. **Private repo** (`seeshellontheseasaw`) is sourced at shell startup if present - not included here
10. **Pi agent** settings are symlinked to `~/.pi/agent/settings.json`
