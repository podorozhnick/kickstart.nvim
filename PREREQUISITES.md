# Prerequisites

System packages and tools required for this Neovim config to work fully.
Built up from `:checkhealth` findings on fresh installs.

## Clipboard

**Local desktop session** — install based on `echo $XDG_SESSION_TYPE`:

```bash
# Wayland
sudo apt install wl-clipboard       # Debian / Ubuntu
sudo dnf install wl-clipboard       # Fedora

# X11
sudo apt install xclip              # Debian / Ubuntu
sudo dnf install xclip              # Fedora
```

Neovim auto-detects whichever is installed.

**Headless / SSH** — no system clipboard exists. `init.lua` detects `$SSH_TTY`
and registers an OSC 52 clipboard provider, which sends yanks up the SSH
connection to the *local* terminal's clipboard. Requirements:

- Local terminal must support OSC 52 (kitty, wezterm, alacritty, iTerm2,
  Windows Terminal — yes; gnome-terminal — no by default).
- Inside tmux, add to `~/.tmux.conf`: `set -g set-clipboard on`
- Paste from system clipboard via OSC 52 only works in some terminals
  (kitty yes, most others no). Copy is reliable; for pasting in,
  use the terminal's own paste shortcut into insert mode.

## ripgrep

Powers telescope live grep and other search pickers.

```bash
sudo apt install ripgrep            # Debian / Ubuntu
sudo dnf install ripgrep            # Fedora
```

## luarocks (optional — currently unused)

`:checkhealth lazy` warns that hererocks/luarocks isn't installed. None of the
plugins in this config require luarocks, so the warning is safe to ignore.

To silence it, either install luarocks system-wide:

```bash
sudo apt install luarocks           # Debian / Ubuntu
sudo dnf install luarocks           # Fedora
```

…or disable luarocks support in the `lazy.setup` call in `init.lua` by adding:

```lua
rocks = { enabled = false },
```

## tree-sitter-cli (optional — currently unused)

`:checkhealth nvim-treesitter` warns this is missing. It's only needed for
`:TSInstallFromGrammar` or building parsers from source. Normal
`:TSInstall <lang>` downloads prebuilt parsers and works without it.

To install if you want it:

```bash
sudo apt install tree-sitter-cli    # Debian (trixie+) / Ubuntu (24.04+)
sudo dnf install tree-sitter-cli    # Fedora

# Fallback if package not available
cargo install tree-sitter-cli
# or
npm install -g tree-sitter-cli
```
