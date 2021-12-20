# Add `~/bin` to the `$PATH`
export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:/Applications/MAMP/bin/php/php7.0.0/bin:$HOME/bin:$PATH"

# Brew OpenSSL
export PATH="/usr/local/opt/openssl/bin:$PATH"

# Tell Homebrew Cask to install files to /etc/Caskroom and symlink to root Applications directory
export HOMEBREW_CASK_OPTS="--appdir=/Applications --caskroom=/etc/Caskroom"

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the OhMyZSH theme to load.
# Look in ~/.oh-my-zsh/themes/
# ZSH_THEME="dstufft"
# ZSH_THEME="cobalt2"
# ZSH_THEME="powerlevel9k/powerlevel9k"
ZSH_THEME="shades-of-purple"

# Load the shell dotfiles, and then some:
# * ~/.mix-path can be used to extend `$PATH`.
# * ~/.mix-extra can be used for other settings you don’t want to commit to your repo.
for file in ~/.mix-{path,exports,aliases,extra}; do
	[ -r "$file" ] && source "$file"
done
unset file

#--- Powerlevel9k Theme only ---#
# @url https://medium.com/@Clovis_app/configuration-of-a-beautiful-efficient-terminal-and-prompt-on-osx-in-7-minutes-827c29391961
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir rbenv vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
# Add a space in the first prompt
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="♎︎"
# Visual customisation of the second prompt line
local user_symbol="$"
if [[ $(print -P "%#") =~ "#" ]]; then
    user_symbol = "#"
fi
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%{%B%F{black}%K{yellow}%} $user_symbol%{%b%f%k%F{yellow}%} %{%f%}"
# Change the git status to red when something isn't committed and pushed
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='red'
# Add a new line after the global prompt
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
# Colorise the top Tabs of Iterm2 with the same color as background
# Just change the 18/26/33 wich are the rgb values
echo -e "\033]6;1;bg;red;brightness;18\a"
echo -e "\033]6;1;bg;green;brightness;26\a"
echo -e "\033]6;1;bg;blue;brightness;33\a"


# --- ZSH CONFIG -----------------------
# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"


# --- PLUGINS ----------------------------------
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# plugins=(git brew bundler capistrano cloudapp composer gem laravel npm rvm bower sublime)
# plugins=(git zsh-syntax-highlighting vi-mode)
plugins=(
  git
  zsh-autosuggestions
  yarn
  web-search
  jsontools
  macports
  node
  macos
  sudo
  thor
  docker
)

source $ZSH/oh-my-zsh.sh
