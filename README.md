# v

A minimal, preconfigured Neovim distribution. Installs as its own command (`v`),
with Neovim vendored privately inside the package — no separate Neovim install
required, no dependency shown in `brew list`.

## Install

```
brew tap snesjhon/v https://github.com/snesjhon/v
brew install v
```

## Run

```
v
```

First launch installs plugins (via native `vim.pack`) and treesitter parsers;
every launch after that is instant. All state (plugins, undo, shada) lives
under `~/.local/share/v` and `~/.local/state/v`, fully isolated from any
other Neovim install on the machine.

## Customizing

Create `~/.config/v/init.lua` and it will be loaded automatically on top of
the bundled defaults. Nothing to opt into beyond creating the file; nothing
breaks if it's absent.
