#!/bin/bash
# This script is designed to loop over the files in a directory, and convert any .mkv files to a .mp4 format.
# It is required that you have ffmpeg installed
# We won't overwrite an existing mp4 file if one already exists with the same name

if ! command -v ffmpeg >/dev/null 2>$1 ; then
	echo "missing required dependency ffmpeg" && exit 2
fi


helpFunction()
{
	echo "Convert mkv files to mp4 format using the same codec"
	echo "Usage $0 -d directory [-v] [-k]"
	echo -e "\t -d the directory containing files to convert"
	echo -e "\t -v prints each file examined, and not just errors"
	echo -e "\t -k kill the original mkv file after conversion"
	exit 1 # Exit script after printing help
}

convertFile()
{
	local fullFilename="$1"
	local verbose="$2"
	local killFile="$3"
	local extension="${fullFilename##*.}"
	local filename="${fullFilename%.*}"
	if [ $extension == "mkv" ]
	then
		if [ $verbose == "true" ]
		then 
			echo "converting $fullFilename"
		fi

		ffmpeg -n -hide_banner -loglevel error -i "$fullFilename" -c copy "$filename"".mp4"
		
		if [ $killFile == "true" ]
		then
			rm "$fullFilename"
		fi
	else
		if [ $verbose == "true" ]
		then
			echo "$fullFilename is not an mkv file"
		fi
	fi
}

verbose=false
killFile=false

while getopts d:vkh flag
do
	case "${flag}" in
		d ) directory=${OPTARG};;
		v ) verbose=true;;
		k ) killFile=true;;
		h ) #display help
			helpFunction;;
	esac
done

#validate the directory
[ -z "$directory" ] && echo "directory is required" && exit 13
[ ! -d "$directory" ] && echo "invalid directory: $directory" && exit 2

echo "processing directory: $directory"

cd "$directory"
for filename in ./*; do
	convertFile "$filename" "$verbose" "$killFile"
done
