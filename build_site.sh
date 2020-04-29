#!/usr/bin/env bash

## Constants
source settings
if [[ "$PODCAST_SLUG" == "" || "$YT_PLAYLIST" == "" ]]; then
  echo "Please edit settings first."
  exit 1
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
octopod serve

# deploy site
octopod deploy