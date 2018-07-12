#!/bin/bash

# Update Ruby to latest stable mainstream version
echo "Updating Ruby..."
RUBYVERSION=$(rbenv install -l | grep -v - | tail -1 | sed -e 's/^[[:space:]]*//')
echo "Latest stable: $RUBYVERSION"
rbenv install "$RUBYVERSION"
rbenv global "$RUBYVERSION"
gem update --system


