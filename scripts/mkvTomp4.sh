#!/bin/bash
# This script is designed to loop over the files in a directory, and convert any .mkv files to a .mp4 format using H.264 video encoding at frame rate of 30, and AAC audio encoding.
# If multiple video tracks exist, only the first video track will be encoded.
# If one exists, the English audio track will be set as the default audio track.
#
# It is required that you have ffmpeg installed
# We won't overwrite an existing mp4 file if one already exists with the same name

if ! command -v ffmpeg >/dev/null 2>$1 ; then
	echo "missing required dependency ffmpeg" && exit 2
fi


helpFunction()
{
	echo "Convert mkv files to mp4 format using the same codec"
	echo "Usage $0 -d directory [-v] [-k] [-l]"
	echo -e "\t -d directory\tthe directory containing files to convert"
	echo -e "\t -v\tprints each file examined, and not just errors"
	echo -e "\t -k\tkill the original mkv file after conversion"
	echo -e "\t -l loglevel\tlog level for ffmpeg to use. Default to 'error'"
	exit 1 # Exit script after printing help
}

convertFile()
{
	local fullFilename="$1"
	local verbose="$2"
	local killFile="$3"
	local logLevel="$4"

	local extension="${fullFilename##*.}"
	local filename="${fullFilename%.*}"
	if [ $extension == "mkv" ]
	then
		if [ $verbose == "true" ]
		then 
			echo "converting $fullFilename"
		fi
		
		ffmpeg -n -hide_banner -loglevel "$logLevel" -i "$fullFilename" -map 0:v -map 0:a -map 0:s -disposition:a:m:language:eng default -c copy -c:v h264 -r 30 -c:a aac -c:s mov_text "$filename"".mp4"
		
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
logLevel=error

while getopts d:l:vkh flag
do
	case "${flag}" in
		d ) directory=${OPTARG};;
		v ) verbose=true;;
		k ) killFile=true;;
		l ) logLevel=${OPTARG};;
		h ) #display help
			helpFunction;;
	esac
done

#validate the directory
[ -z "$directory" ] && echo "directory is required" && exit 13
[ ! -d "$directory" ] && echo "invalid directory: $directory" && exit 2

if [ $verbose == "true" ]
then
	echo "p[rocessing directory: $directory"
fi

cd "$directory"
for filename in ./*; do
	convertFile "$filename" "$verbose" "$killFile" "$logLevel"
done
