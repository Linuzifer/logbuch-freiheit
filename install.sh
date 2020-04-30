#!/usr/bin/env bash

# constants
source settings
if [[ "$PODCAST_SLUG" == "" || "$YT_PLAYLIST" == "" ]]; then
	echo "please edit settings first."
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
echo <<EOF >> Gemfile
source "https://rubygems.org"
gem "jekyll", "~> 4.0"
gem "jekyll-octopod"
EOF
bundle install
sudo gem install jekyll-octopod
octopod setup
rm index.markdown
git checkout "$PODCAST_SLUG/_config.yml" # It makes sense to keep this config in the repo. Make sure not to push sensitive information.
git checkout "$PODCAST_SLUG/imprint.md"  # It makes sense to keep imprint in the repo.