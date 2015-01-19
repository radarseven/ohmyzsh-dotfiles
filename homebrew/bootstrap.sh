# Install Homebrew (http://brew.sh)
# ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install oh-my-zsh to beautify and manage zsh
# curl -L http://install.ohmyz.sh | sh

# Update Homebrew
brew update

# Upgrade Homebrew
brew upgrade

# install brew taps, needs to be fixed properly later
while read in; do brew tap "$in"; done < Taps

# Install brews
brew install $(cat Brewfile|grep -v "#")

# Install casks
brew cask install $(cat Caskfile|grep -v "#")

# Cleanup
brew cleanup

# Set standard settings
# source 'settings.sh'
# source 'symlink-dotfiles.sh'

# Update OS X
# sudo softwareupdate -i -a