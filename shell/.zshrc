# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH"

# Node modules (local project binaries)
export PATH="$PATH:./node_modules/.bin"

# Path to your oh-my-zsh configuration
ZSH=$HOME/.oh-my-zsh

# Disable OMZ theme (using Starship instead)
ZSH_THEME=""

# Load the shell dotfiles, and then some:
# * ~/.mix-path can be used to extend `$PATH`.
# * ~/.mix-extra can be used for other settings you don't want to commit to your repo.
for file in ~/.mix-{path,exports,aliases,extra}; do
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

# Starship prompt (must be last)
eval "$(starship init zsh)"
