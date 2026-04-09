# Work Machine Setup Guide

After running `./bootstrap.sh` and restoring the repo versions (`git checkout -- .`), follow these steps to configure machine-specific settings.

## 1. Install Homebrew Packages + Modern CLI Tools

```bash
brew bundle                    # From ~/.dotfiles
brew install --cask font-monaspace-nf   # Terminal font
```

Set your terminal font to **Monaspace Neon NF** (or MesloLGS NF).

## 2. Create `~/.mix-extra`

Create this file manually — it is never committed to the repo.

```bash
cat > ~/.mix-extra << 'EXTRA'
# --- WORK MACHINE CONFIG (not committed) ---

# Kiro CLI
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"

# Android Studio JDK
export PATH="/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin:$PATH"

# Ruby (Homebrew)
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

# Docker CLI completions
fpath=(${HOME}/.docker/completions $fpath)
autoload -Uz compinit
compinit

# WebstaurantStore
alias dotnet:certs-clean="dotnet dev-certs https --clean"
alias dotnet:certs-build="dotnet dev-certs https --trust"

# Kiro CLI post block
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"
EXTRA
```

## 3. Set Work Git Email

The repo's `.gitconfig` includes `~/.gitconfig.local` (which git silently ignores if missing). Create it on this machine to override your email globally:

```bash
cat > ~/.gitconfig.local << 'EOF'
[user]
    email = my@workemail.gov
EOF
```

This file is never committed. All repos on this machine will use your work email.

## 4. Reload

```bash
source ~/.zshrc
```

## Checklist

- [ ] `brew bundle` completed
- [ ] Nerd Font installed and set in terminal(s)
- [ ] `~/.mix-extra` created with work-specific config
- [ ] Git work email configured (includeIf or global override)
- [ ] `source ~/.zshrc` runs without errors
- [ ] Starship prompt renders correctly
- [ ] `eza`, `bat`, `fzf`, `zoxide` all working (`ls`, `cat`, Ctrl-R, `z`)
