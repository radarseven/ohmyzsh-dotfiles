# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH"

# Node modules (local project binaries)
export PATH="$PATH:./node_modules/.bin"

# Path to your oh-my-zsh configuration
ZSH=$HOME/.oh-my-zsh

# Disable OMZ theme (using Starship instead)
ZSH_THEME=""

# Load path and environment config (before oh-my-zsh)
# .mix-tags layers ~/.mix-tags.d/<tag>.zsh per ~/.config/dotfiles/profile
for file in ~/.mix-{path,exports,aliases,tags}; do
	[ -r "$file" ] && source "$file"
done
unset file

# --- ZSH CONFIG -----------------------
# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# --- PLUGINS ----------------------------------
plugins=(
  docker
  git
  jsontools
  macos
  node
  sudo
  yarn
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# Load private/machine-specific config (after oh-my-zsh, so compdef is available)
[ -r ~/.mix-extra ] && source ~/.mix-extra

# --- TOOL INITIALIZATION ----------------------

# mise (Node.js version manager — config in ~/.config/mise/config.toml)
# Guarded so a machine that hasn't run ./bundle.sh yet still gets a clean shell
command -v mise > /dev/null && eval "$(mise activate zsh)"

# fzf (fuzzy finder: Ctrl-R history, Ctrl-T file picker, Alt-C cd)
source <(fzf --zsh)

# zoxide (smart cd — use `z` command)
eval "$(zoxide init zsh)"

# zsh-syntax-highlighting (must be near end of .zshrc)
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# Use SSH-friendly Starship config when connecting remotely (no Nerd Font icons)
if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
  export STARSHIP_CONFIG="$HOME/.config/starship-ssh.toml"
fi

# Starship prompt (must be last)
eval "$(starship init zsh)"

# --- END OF MANAGED CONFIG --- #
# ~/.zshrc is an untracked stub that sources this file (see bootstrap.sh).
# Tools that auto-inject into ~/.zshrc (Herd, Kiro, ...) append to the stub,
# so nothing should ever appear below this line. Machine-specific config
# belongs in ~/.mix-extra.
