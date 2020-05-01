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

# backup existing jekyll setup

if [[ -d "$PODCAST_SLUG" ]]; then
	timestamp=`date +%Y-%m-%d.%H.%M`
	mv "$PODCAST_SLUG" "$timestamp.$PODCAST_SLUG"
	mkdir -p "$PODCAST_SLUG"
fi

# setup jekyll
sudo gem install bundler jekyll
jekyll new "$PODCAST_SLUG"
cd "$PODCAST_SLUG"

# octopod setup
cat <<EOF > Gemfile
source "https://rubygems.org"
gem "jekyll", "~> 4.0.0"
gem "jekyll-octopod"
EOF
bundle install
sudo gem install jekyll-octopod
octopod setup

# octopod cleanup
rm index.markdown
rm episodes/episode0.*
rm _posts/2016-03-22-episode0.md
rm _posts/*-welcome-to-jekyll.markdown
rm feed.mp3.json
rm feed.ogg.json
rm episodes.mp3.rss
rm episodes.ogg.rss