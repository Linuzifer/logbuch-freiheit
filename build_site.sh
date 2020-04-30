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

if [[ ! -f "$PODCAST_SLUG/apple-touch-icon-precomposed.png" ]]; then
	echo "we need to run the installer first…" # apple-touch-icon-precomposed.png is created during optopod setup
	./install.sh
fi

## functions
source include/functions

# create needed folders
mkdir -p youtube

# check for required software
require ffmpeg
require youtube-dl

# import youtube playlist
cd youtube
youtube-dl --write-info-json --add-metadata "$YT_PLAYLIST"
for file in ./*.mp4; do
 filename=$(basename -- "$file")
 extension="${filename##*.}"
 filename="${filename%.*}"
 metadata="$filename.info.json"
 slug=`getslug "$file" "$YT_PREFIX"`
 videofile="../$PODCAST_SLUG/episodes/$slug.$extension"
 audiofile="../$PODCAST_SLUG/episodes/$slug.m4a"
 ln "$file" "$videofile"
 ffmpeg -n -i "$videofile" -vn -acodec copy "$audiofile"
 python3 ../import_metadata.py "$metadata"
done

# preview site
cd "../$PODCAST_SLUG"
open http://localhost:4000
octopod serve

# deploy site
echo "Deploy? [ctrl+c / enter]"
read yourmind
octopod build
octopod deploy
