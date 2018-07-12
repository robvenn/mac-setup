#!/bin/bash

# Prompt client for install
read -p "Would you like to setup your dev machine? (y/n)" PROMPT

# Exit if install not confirmed
if [[ $PROMPT != "Y" && $PROMPT != "y" ]]; then
    exit
fi

echo "Starting setup..."

# Install XCode Command Line Tools
xcode-select --install

# Check for Homebrew & install if not found
if test ! "$(which brew)"; then
    echo "Installing homebrew..."
    ruby <(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)
fi

# Update Homebrew recipes & check status
brew update
brew doctor

# Install binaries with Homebrew
BREW_BINARIES=(
    git
    gh
    tmux
    shellcheck
    tree
    mongodb
    postgres
    redis
    rbenv
    yarn
    go
    homebrew/cask-versions/java8
    ant
    maven
    gradle
)

echo "Installing Homebrew binaries..."
brew install "${BREW_BINARIES[@]}"

# Set git to use the osxkeychain credential helper
git config --global credential.helper osxkeychain

# Restart launchctl for db services
brew_launchctl_restart() {
    local name="$(brew_expand_alias "$1")"
    local domain="homebrew.mxcl.$name"
    local plist="$domain.plist"

    mkdir -p "$HOME/Library/LaunchAgents"
    ln -sfv "/usr/local/opt/$name/$plist" "$HOME/Library/LaunchAgents"

    if launchctl list | grep -q "$domain"; then
        launchctl unload "$HOME/Library/LaunchAgents/$plist" >/dev/null
    fi
    launchctl load "$HOME/Library/LaunchAgents/$plist" >/dev/null
}
brew_expand_alias() {
  brew info "$1" 2>/dev/null | head -1 | awk '{gsub(/:/, ""); print $1}'
}

echo "Restarting Postgres..."
brew_launchctl_restart postgresql

echo "Restarting MongoDB..."
brew_launchctl_restart mongodb

# Update Ruby to latest stable mainstream version
echo "Updating Ruby..."
RUBYVERSION=$(rbenv install -l | grep -v - | tail -1 | sed -e 's/^[[:space:]]*//')
echo "Latest stable: $RUBYVERSION"
rbenv install "$RUBYVERSION"
rbenv global "$RUBYVERSION"
gem update --system

# Install latest NVM with the install script, homebrew not supported
curl -o https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
# This will add nvm path to & load nvm from ~/.bashrc, reload it to use nvm
source ~/.bashrc

# Install Node.js with nvm (latest stable Node version)
echo "Installing Node..."
nvm install stable
nvm use stable
nvm alias default stable

# NPM global packages
# echo "Installing global npm packages..."
# NPM_PACKAGES=()
# npm install -g "${NPM_PACKAGES[@]}"

# Install applications with Homebrew-cask
echo "Installing OS X applications with Homebrew-Cask..."
brew tap caskroom/cask
CASK_APPS=(
    google-chrome
    firefox
    opera
    sourcetree
    sequel-pro
    pgadmin4
    robo-3t
    virtualbox
    vagrant
    vagrant-manager
    dropbox
    skype
    vlc
    spotify
    cheatsheet
    qlcolorcode
    qlstephen
    qlmarkdown
    quicklook-json
    quicklook-csv
    betterzipql
    suspicious-package
    caffeine
    limechat
    android-sdk
    android-ndk
    android-studio
)
brew cask install "${CASK_APPS[@]}"

# Clean up after installation
brew cleanup

echo "We're done!"
