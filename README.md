# Youtube audio podcast generator

This collection of scripts creates an audio podcast web site + feed from a YouTube playlist.
I built this as a quick hack for [logbuch-freiheit.de](https://logbuch-freiheit.de).
It heavily relies on [octopod](https://github.com/jekyll-octopod/jekyll-octopod) as well as [youtube-dl](https://github.com/ytdl-org/youtube-dl) and [ffmpeg](https://github.com/FFmpeg/FFmpeg) for scraping and format conversion.

This can probably be used to import just about any YouTube-Channel after you make a couple of edits to the settings.

## Limitations

This repository contains a couple of undocumented modifications for the target site [logbuch-freiheit.de](https://logbuch-freiheit.de). You can easily remove them from the ```install.sh``` script.

## Usage

### 1. Customize settings

```console
# youtube import settings
cp settings.py.example settings.py
nano settings.py
cp settings.example settings
nano settings

# octopod settings
nano config.yml
```

### 2. Build site

```./install.sh``` will be called at first launch, so you can immediately run the site builder.

```console
./build_site.sh
```

### 3. Deploy site

After preview, you you will be prompted for file upload.