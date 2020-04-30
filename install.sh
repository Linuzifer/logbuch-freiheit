#!/usr/bin/env bash

# constants
source settings
if [[ "$PODCAST_SLUG" == "" || "$YT_PLAYLIST" == "" ]]; then
	echo "please edit settings first."
	echo "to restore from repo:"
	echo "cp settings.py.example settings.py"
    echo "cp settings.example settings"
	exit 1
fi

# functions
source include/functions

# dependencies
require ruby

# setup jekyll
sudo gem install bundler jekyll
jekyll new "$PODCAST_SLUG"
cd "$PODCAST_SLUG"

# setup octopod
cat <<EOF > Gemfile
source "https://rubygems.org"
gem "jekyll", "~> 4.0.0"
gem "jekyll-octopod"
EOF
bundle install
sudo gem install jekyll-octopod
octopod setup
rm index.markdown
cp ../_config.yml .
cp ../imprint.md .
rm episodes/episode0.*
rm _posts/2016-03-22-episode0.md
rm _posts/*-welcome-to-jekyll.markdown
