# Michael's Dotfiles

![Rikerized](docs/rikerized.jpg)

macOS dotfiles for an opinionated terminal setup. Managed with [GNU Stow](https://www.gnu.org/software/stow/), powered by ZSH + [Oh-My-Zsh](https://ohmyz.sh/) + [Starship](https://starship.rs/).

Originally adapted from [Mathias Bynens' dotfiles](https://github.com/mathiasbynens/dotfiles), heavily customized over the years, and comprehensively modernized in April 2026 (see [docs/RIKERIZE.md](docs/RIKERIZE.md)).

## What's Inside

| Package | Contents | Stowed to |
|---------|----------|-----------|
| `shell/` | .zshrc, .mix-aliases, .mix-exports, .mix-path | `~/` |
| `git/` | .gitconfig, .global-gitignore | `~/` |
| `vim/` | .vimrc, .gvimrc, .vim/ | `~/` |
| `wget/` | .wgetrc | `~/` |
| `bin/` | Custom scripts | `~/bin/` |
| `config/` | starship.toml | `~/.config/` |

Plus:
- `Brewfile` — Homebrew packages (`brew bundle` to install)
- `bootstrap.sh` — Symlinks everything to `~/` via Stow
- `.osx` — macOS system defaults (run manually, review first)

## Modern CLI Tools

These dotfiles alias standard commands to modern replacements:

| You type | You get | Why |
|----------|---------|-----|
| `ls` | [eza](https://github.com/eza-community/eza) | Icons, git awareness, tree view |
| `cat` | [bat](https://github.com/sharkdp/bat) | Syntax highlighting |
| `grep` | [ripgrep](https://github.com/BurntSushi/ripgrep) (as `rg`) | Much faster, respects .gitignore |
| `find` | [fd](https://github.com/sharkdp/fd) (as `fd`) | Simpler syntax, faster |
| `cd` | [zoxide](https://github.com/ajeetdsouza/zoxide) (as `z`) | Learns your habits |
| Ctrl-R | [fzf](https://github.com/junegunn/fzf) | Fuzzy history search |
| `git diff` | [delta](https://github.com/dandavison/delta) | Side-by-side, syntax highlighting |

## Installation

### Quick Start

```bash
git clone git@github.com:radarseven/ohmyzsh-dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh     # Symlink everything to ~/
brew bundle         # Install Homebrew packages
source ~/.zshrc     # Reload shell
```

### Prerequisites

- macOS with [Homebrew](https://brew.sh/) installed
- [Oh-My-Zsh](https://ohmyz.sh/) installed
- A [Nerd Font](https://www.nerdfonts.com/) for terminal icons (e.g., MesloLGS NF)

### Stow a Single Package

```bash
cd ~/.dotfiles
stow -R -t ~ shell    # Just shell config
stow -R -t ~ git      # Just git config
```

### Private Config (`~/.mix-extra`)

`~/.mix-extra` is your machine-specific, private config file. It's sourced automatically by `.zshrc` (after oh-my-zsh loads, so completions work) and is **never committed** to the repo.

**What goes where:**

| File | What goes in it | In repo? |
|------|----------------|----------|
| `shell/.mix-aliases` | Aliases and functions | Yes |
| `shell/.mix-path` | PATH additions | Yes |
| `shell/.mix-exports` | Environment variables | Yes |
| `~/.mix-extra` | Secrets, API keys, machine-specific tools | No |

**Put things in `.mix-extra` when they are:**
- API keys, tokens, or secrets
- Tool hooks that are machine-specific (Herd PHP, Kiro CLI, OpenClaw, etc.)
- Work-specific config you don't want public
- Anything auto-injected by installers (see below)

**Dealing with tools that auto-inject into `.zshrc`:**

Since `~/.zshrc` is a symlink to the repo, tools that auto-modify it (like Herd, Kiro, etc.) will dirty your git state. When this happens:

```bash
cd ~/.dotfiles
git diff shell/.zshrc              # See what got injected
# Move the injected lines to ~/.mix-extra
code ~/.mix-extra
git checkout -- shell/.zshrc       # Restore the clean version
source ~/.zshrc                    # Reload
```

## Syncing Another Machine

Already have dotfiles in `~/` on another Mac that have drifted from this repo? Here's how to safely adopt the new setup without losing anything.

**1. Clone (or pull) the repo**
```bash
# Fresh machine:
git clone git@github.com:radarseven/ohmyzsh-dotfiles.git ~/.dotfiles

# Already cloned:
cd ~/.dotfiles && git pull
```

**2. Switch to enterprise and run bootstrap**
```bash
cd ~/.dotfiles
git checkout enterprise
./bootstrap.sh
```
This backs up all your existing `~/` dotfiles to `~/.dotfiles-backup/<timestamp>/`, then creates symlinks. Nothing is destroyed.

**3. See what drifted**
```bash
git diff
```
Every file where your live version differed from the repo will show as modified. This is `stow --adopt` pulling in your live files so you can review them.

**4. Decide what to keep**
- **Keep repo version** (most common): `git checkout -- <file>`
- **Keep everything from repo**: `git checkout -- .`
- **Merge both**: edit the file to keep what you want, discard the rest
- **Machine-specific stuff**: move it to `~/.mix-extra` (see below)

**5. Move machine-specific config to `~/.mix-extra`**

Anything unique to that machine (tool hooks, work config, API keys) should go in `~/.mix-extra`, not in the repo files. See the [Private Config](#private-config-mix-extra) section.

**6. Reload and install tools**
```bash
source ~/.zshrc
brew bundle          # Install Homebrew packages
```

**Your safety net**: backups are in `~/.dotfiles-backup/`. Check with `ls ~/.dotfiles-backup/`.

---

## Beam Me Up, Scotty

Not feeling the modernized setup? Don't worry — every run of `bootstrap.sh` automatically backs up your existing `~/` dotfiles to `~/.dotfiles-backup/<timestamp>/` before touching anything.

### Restore from Backup

If something goes sideways, your previous files are safe:

```bash
cd ~/.dotfiles

# 1. Unstow everything (removes symlinks from ~/)
stow -D -t ~ shell git vim wget bin config

# 2. Copy your backed-up files back
cp -a ~/.dotfiles-backup/<timestamp>/. ~/

# 3. Reload
source ~/.zshrc
```

List available backups with `ls ~/.dotfiles-backup/`.

### Full Rollback to Pre-Modernization

```bash
cd ~/.dotfiles

# 1. Unstow all current packages (removes symlinks from ~/)
stow -D -t ~ shell git vim wget bin config

# 2. Switch to the legacy branch
git checkout beam-me-up-scotty

# 3. Run the old rsync bootstrap (copies files to ~/)
./bootstrap.sh

# 4. Reload your shell
source ~/.zshrc
```

### Return to Enterprise

```bash
cd ~/.dotfiles

# 1. Switch back to the modernized branch
git checkout enterprise

# 2. Run the stow bootstrap (creates symlinks in ~/)
./bootstrap.sh

# 3. Reload your shell
source ~/.zshrc
```

### Just Peek at the Old Setup

```bash
# View the old configs without switching
git show beam-me-up-scotty:.zshrc
git show beam-me-up-scotty:.mix-aliases
git diff beam-me-up-scotty..enterprise -- shell/.mix-aliases
```

## Branches & Tags

| Name | Type | Purpose |
|------|------|---------|
| `enterprise` | branch | Main branch (modernized, Stow-based) |
| `beam-me-up-scotty` | branch | Legacy snapshot (rsync-based, pre-2026) |
| `legacy/pre-modernization` | tag | Exact commit before modernization began |
| `hell-yaw` | tag | Same commit. You know what it means. |

## The RIKERIZE

For the full story of the modernization — what changed, why, and all the gory details — see [docs/RIKERIZE.md](docs/RIKERIZE.md).

## Shell Aliases Cheat Sheet

```bash
cc          # Launch Claude Code
ccc         # Continue last Claude conversation
ccr         # Resume a Claude conversation
refresh     # Reload .zshrc
z <partial> # Smart cd (zoxide)
tree        # Directory tree with icons
c <file>    # Syntax-highlighted file view (bat)
```

See `shell/.mix-aliases` for the full list.

## Credits

Originally based on [Mathias Bynens' dotfiles](https://github.com/mathiasbynens/dotfiles), adapted for ZSH by [Matt Stauffer](https://github.com/mattstauffer), and rikerized with [Claude Code](https://claude.ai/code).
