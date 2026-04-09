# RIKERIZE: Dotfiles Modernization Plan

> "Make it so." - Jean-Luc Picard

Executed April 2026. This document records the comprehensive modernization of these dotfiles from their ~2015-era Mathias Bynens origins to a modern, AI-integrated, Stow-managed setup.

The name comes from [jquery.rikerize.js](jquery.rikerize.js) — a Konami code-style Easter egg plugin from the bresnan.com era (~2012) that triggers when you type "RIKER". It felt right.

## What Changed

### Before (beam-me-up-scotty branch)
- rsync-based bootstrap (copies files to ~/)
- Oh-My-Zsh + Powerlevel10k prompt
- Standard coreutils (ls, cat, grep, find)
- Outdated Brewfile with PHP 5.4, Rdio (RIP), ColdFusion paths
- Intel-era paths (/usr/local) on Apple Silicon
- Accumulated legacy cruft from a decade of use

### After (enterprise branch)
- GNU Stow-based bootstrap (symlinks to ~/)
- Oh-My-Zsh + Starship prompt (Rust-based, TOML config)
- Modern CLI tools: eza, bat, fd, ripgrep, fzf, zoxide, delta
- Clean Brewfile with `brew bundle` format
- Apple Silicon native paths
- Delta-powered git diffs with side-by-side view
- Claude Code integration

## Phase Breakdown

### Phase 0: Preserve Legacy
- Created `beam-me-up-scotty` branch for rollback
- Tagged `legacy/pre-modernization` and `hell-yaw`
- Renamed default branch: `master` -> `enterprise`

### Phase 1: Legacy Cleanup
- Removed ColdFusion 2016, MAMP, Heroku, PostgreSQL dead paths from `.mix-path`
- Removed deprecated `GREP_OPTIONS` and duplicate `HOMEBREW_CASK_OPTS` from `.mix-exports`
- Removed 15+ dead aliases: subl, bower, pygmentize, growlnotify, dandelion, vMox block
- Updated Python 2 aliases to Python 3 (pyserver, urlencode)
- Cleaned .zshrc: removed Fig/CodeWhisperer blocks, P9K settings, NVM config, Intel paths

### Phase 2: Modern CLI Tools
Installed via Homebrew:
- `eza` - ls replacement with icons and git awareness
- `bat` - cat replacement with syntax highlighting
- `fd` - find replacement, faster and friendlier
- `ripgrep` - grep replacement, blazingly fast
- `fzf` - fuzzy finder (Ctrl-R history, Ctrl-T files, Alt-C dirs)
- `zoxide` - smart cd that learns your habits
- `git-delta` - beautiful side-by-side git diffs
- `jq` - JSON processor
- `htop` - better top
- `stow` - dotfile symlink manager
- `starship` - modern shell prompt

### Phase 3: Git Config Upgrades
- Added delta as pager with side-by-side diffs and Dracula theme
- Changed `push.default` from `matching` (dangerous) to `current`
- Added `push.autoSetupRemote = true`
- Added `pull.rebase = true`
- Added `rerere.enabled = true` (remember conflict resolutions)
- Added `init.defaultBranch = main`
- Removed vMox-specific aliases and hardcoded master branch config
- Updated .global-gitignore with .env, .claude/, .terraform/, .venv/

### Phase 4: Brewfile Modernization
- Deleted old `homebrew/` directory (Brewfile, Caskfile, Taps, bootstrap.sh)
- Deleted old `.brewfile`
- Created modern `Brewfile` in repo root using `brew bundle` format
- Organized into sections: CLI Essentials, Modern CLI, Development, Utilities, ZSH

### Phase 5: Starship Prompt
- Replaced Powerlevel10k with Starship (Rust-based, cross-shell)
- Created `starship.toml` with custom config:
  - Git branch/status with ahead/behind counts
  - Node.js, PHP, Ruby, Python version indicators
  - Command duration for slow commands (>2s)
  - Docker context when active
  - Nerd Font symbols
- Cleaned up OMZ plugins: removed asdf, macports, thor, web-search

### Phase 6: Bootstrap Migration
- Restructured repo into Stow packages: shell/, git/, vim/, wget/, bin/, config/
- Rewrote `bootstrap.sh` to use `stow --adopt` for safe migration
- Config files are now symlinked, not copied - edits in ~/ are edits in the repo

### Phase 7: AI / Claude Code Integration
- Created `CLAUDE.md` with project context
- Added shell aliases: `cc` (claude), `ccc` (--continue), `ccr` (--resume)

## Switching Between Setups

```bash
# Go back to the old setup
git checkout beam-me-up-scotty && ./bootstrap.sh

# Return to the modernized setup
git checkout enterprise && ./bootstrap.sh
```

## Tools Reference

| Old | New | What Changed |
|-----|-----|-------------|
| `ls` | `eza` | Icons, git awareness, tree view |
| `cat` | `bat` | Syntax highlighting, line numbers |
| `find` | `fd` | Simpler syntax, faster, respects .gitignore |
| `grep` | `ripgrep` | Much faster, better defaults |
| `cd` | `zoxide` | Learns your habits, fuzzy matching |
| `git diff` | `delta` | Side-by-side, syntax highlighting |
| Ctrl-R | `fzf` | Fuzzy history search |
| Powerlevel10k | Starship | Rust-based, TOML config, cross-shell |
| rsync bootstrap | GNU Stow | Symlinks instead of copies |
