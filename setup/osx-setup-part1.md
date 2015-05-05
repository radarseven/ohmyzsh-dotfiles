# New System Setup

## SSH Setup

### Creating new keys

If performing a clean install on a pre-existing machine, it is recommended to maintain the same keys.

For a new machine, generate a new key pair:

`ssh-keygen -t rsa`

### SSH Config

I like to symlink my SSH `config` file with Dropbox:

`ln -s /path/to/ssh/config ~/.ssh/config`

## Install Oh-My-Szh

`curl -L http://install.ohmyz.sh | sh`

## Install Homebrew

`ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"`

## Install Homebrew Cask

`brew install caskroom/cask/brew-cask`

## Configure Homebrew Cask paths

Add the line below to your ~/.zshrc file.

`export HOMEBREW_CASK_OPTS="--appdir=/Applications --caskroom=/etc/Caskroom"`

Reload .zshrc using the command below.

`. ~/.zshrc`

## Install RVM

`\curl -sSL https://get.rvm.io | bash -s stable --ruby`

## Install NPM & Node

[http://nodejs.org/download/](http://nodejs.org/download/)

## Install Necessary Apps

At this point I like to install apps that are convenient and/or necessary to make this process as painless as possible.

`brew cask install dropbox`
`brew cask install alfred`
`brew cask install onepassword`

*Note: You may have to update the permissions of your /etc/Caskroom/ directory*

## Link your Cask installed apps to Alfred

`brew cask alfred link`

## Dotfiles

Feel free to fork and clone [https://github.com/httpster/ohmyzsh-dotfiles](https://github.com/httpster/ohmyzsh-dotfiles)

I clone the repo into ~/Documents/Dotfiles/, but feel free to store this repo anywhere you'd like.

Execute `.bootstrap.sh` to copy files to home directory.

`source bootstrap.sh`

## Run .osx defaults

`cd` into your dotfiles directory and execute .osx

`./.osx`

## Run .brewfile

`cd` into your dotfiles directory and execute .brewfile

`brew bundle .brewfile`

## Import/Symlink

Sublime Text settings, Alfred workflows, Transmit favorites, Sequel Pro favorites, SSH config, PEM keys, Keychains, etc.

## Finder

I like to have toolbar buttons in the Finder for the following:

1. [Open in Sublime Text](https://github.com/pjv/open-in-sublime/downloads)
2. [Open in iTerm](https://github.com/jbtule/cdto)

## [Party Time!](http://dl.dropboxusercontent.com/u/9110843/gifs/partycatswearpartyhats.gif)