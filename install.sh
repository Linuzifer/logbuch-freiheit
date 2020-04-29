#!/usr/bin/env bash

# constants
source settings
if [[ "$PODCAST_SLUG" == "" || "$YT_PLAYLIST" == "" ]]; then
	echo "please edit settings first."
	exit 1
fi

# setup jekyll
sudo gem install bundler jekyll
jekyll new "$PODCAST_SLUG"
cd "$PODCAST_SLUG"

# setup octopod
echo <<EOF >> Gemfile
source "https://rubygems.org"
gem "jekyll", "~> 4.0"
gem "jekyll-octopod"
EOF
bundle install
sudo gem install jekyll-octopod
octopod setup
rm index.markdown