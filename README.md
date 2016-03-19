setup
=====

Setting up a new Mac with OS X for web development.

Run the script to install or upgrade packages.

Tested on OS X Mavericks (10.9) & OS X Yosemite (10.10)


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
* nvm, Node.js, npm
* Yeoman, grunt, bower, gulp, nodemon, phantomjs
* Chrome, Firefox, Opera
* Atom, Sourcetree, Robomongo, Sequel Pro, Pgadmin
* Virtualbox, Vagrant, Vagrant-manager
* Dropbox, Skype, Vlc, Spotify
* Quick look plugins & cheat sheet
* Atom plugins


To do:
------

* Adjusting for OS X 10.11.3 EL Capitan (Work In Progress)
* Better integration with dotfiles (f.e. setting PATH)
* Update / upgrade when already installed


Inspired by:
------------

https://github.com/thoughtbot/laptop
