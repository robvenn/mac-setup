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
    ruby-build
    nvm
    caskroom/cask/brew-cask
)

echo "Installing binaries..."
brew install "${BREW_BINARIES[@]}"

# Set git to use the osxkeychain credential helper
git config --global credential.helper osxkeychain

# update ~/.bashrc to put Homebrew's nvm in PATH (if this doesn't work use ~/.bash_profile)
printf "\nsource $(brew --prefix nvm)/nvm.sh" >> ~/.bashrc

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

# Install Node.js with nvm (latest stable Node version)
echo "Installing Node..."
source $(brew --prefix nvm)/nvm.sh
nvm install stable
nvm use stable
nvm alias default stable

# NPM global packages
echo "Installing global npm packages..."
NPM_PACKAGES=(
    yo
    gulp
    bower
    nodemon
    grunt-cli
    karma-cli
    phantomjs
)
npm install -g "${NPM_PACKAGES[@]}"

# Install applications with Homebrew-cask
echo "Installing OS X applications with Homebrew-Cask..."
CASK_APPS=(
    google-chrome
    firefox
    opera
    atom
    sourcetree
    sequel-pro
    robomongo
    pgadmin3
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
)
brew cask install "${CASK_APPS[@]}"

# Clean up after installation
brew cleanup

# Install Atom plugins
echo "Installing Atom plugins..."
ATOM_PACKAGES=(
    auto-update-packages 
    autocomplete-modules 
    auto-detect-indentation 
    tabs-to-spaces 
    atom-beautify 
    autoclose-html 
    highlight-selected 
    language-babel 
    react 
    linter 
    linter-eslint 
    minimap 
    minimap-highlight-selected 
    pigments 
    seti-ui 
    monokai-seti
)
apm install "${ATOM_PACKAGES[@]}"


echo "We're done!"
