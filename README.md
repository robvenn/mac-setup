setup
=====

Setting up a new Mac with OS X for web development.

Run the script to install or upgrade packages.

Currently updating for OS X 10.11 El Capitan (Work In Progress)


Install
-------
Run this from the command line:

    bash <(curl https://raw.githubusercontent.com/robinvenneman/osx-setup/master/install.sh -s -A '')

Then confirm the message and wait for the script to finish.


What it installs
----------------

* XCode Command Line Tools
* Homebrew and cask
* git, github
* Tmux, shellcheck, tree
* MongoDB, PostgreSQL, redis
* Ruby, rbenv, ruby-build
* nvm, Node.js, npm, yarn
* Chrome, Firefox, Opera
* VS Code, Sourcetree, Robo3T, Sequel Pro, Pgadmin
* Virtualbox, Vagrant, Vagrant-manager
* Dropbox, Skype, Vlc, Spotify
* Quick look plugins & cheat sheet


To do:
------

* Better integration with dotfiles (like setting PATH)


Inspired by:
------------

https://github.com/thoughtbot/laptop
