# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH"

# Node modules (local project binaries)
export PATH="$PATH:./node_modules/.bin"

# Path to your oh-my-zsh configuration
ZSH=$HOME/.oh-my-zsh

# Disable OMZ theme (using Starship instead)
ZSH_THEME=""

# Load path and environment config (before oh-my-zsh)
for file in ~/.mix-{path,exports,aliases}; do
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

# Volta (Node.js version manager)
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

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
# Anything below this line was auto-injected by a tool and should be
# moved to ~/.mix-extra, then restore this file with:
#   git checkout -- shell/.zshrc
