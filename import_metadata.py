#!/usr/local/bin/python3.7
import json
import sys
import datetime
import urllib.request
import os

# parse arguments
if len(sys.argv)<2:
	print(sys.argv[1] + " <file>")
	sys.exit(1)
file=sys.argv[1]

# settings
from settings import *  
if podcast_slug == "" or prefix == "":
	print("please edit settings.py first.")
	sys.exit(1)

# Make sure we are in the youtube directory
working_directory=os.getcwd()
base_directory=os.path.dirname(os.path.realpath(__file__))
if working_directory != base_directory + "/youtube":
	try:
		os.chdir(base_directory + "/youtube")
	except:
		print("We are not where we need to be:")
		print(os.getcwd())
		print("Usually, this script will be called by build_site.sh and you don't need to worry about it.")
		sys.exit(0)

# deduce slug
slug=str(file).replace("- ","").replace("\ ","_").replace(" ","_").replace(prefix,"")[:-22]

# import json
json_file=open(file)
data = json.load(json_file)
# This json has a lot to offer, most of which we are not using. Uncomment the following two lines to get an overview:
# for p in data:
#	print(p, data[p])

# check timestamp
timestamp=str(data["upload_date"][:-4] + "-" + data["upload_date"][-4:-2] + "-" + data["upload_date"][-2:])
post_file=str("../" + podcast_slug + "/_posts/" + timestamp + "-" + slug + ".md")

# download thumbnail
urllib.request.urlretrieve(data["thumbnail"], '../' + podcast_slug + '/img/' + slug + '.jpg') 

# output site
with open(post_file, 'w') as f:
	print("---", file=f)
	print("title: " + data["title"][22:], file=f)
	print("subtitle: " + data["title"][:20], file=f)
	print("image: " + slug + '.jpg', file=f )
	print("datum: " + timestamp, file=f)
	print("layout: post", file=f)
	print("author: Logbuch:Freiheit", file=f)
	print("explicit: 'no'", file=f)
	print("duration: " + str(datetime.timedelta(seconds=data["duration"])), file=f)
	print("audio:", file=f)
	print("  m4a: " + slug + ".m4a", file=f)
	print("  mp4: " + slug + ".mp4", file=f)
	print("---", file=f)
	print("", file=f) 
	print("{% podigee_player page %}", file=f)
	print("", file=f)
	print("Video bei [youtube anschauen](" + data["webpage_url"] + ") oder [als Datei herunterladen](/episodes/" + slug + ".mp4).", file=f)
	print("", file=f)
	for line in data["description"].replace("•","*").splitlines():
		for word in line.split(" "):
			if word.startswith("https://"):
				print("[" + word.replace("https://","") + "](" + word + ")", end =" ", file=f)
			elif word.startswith("@"):
				print("[" + word + "](https://twitter.com/" + word.replace("@","") + ")", end =" ", file=f)	
			else:
				print(word, end =" ", file=f)
		print('\n', file=f)