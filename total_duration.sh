#!/bin/bash

echo "T.D :Total Duration"	"D :Duration"	"F :File name";
start=0;
fileCount=0;
find . -type f -exec file -N -i -- {} + | sed -n 's!: video/[^:]*$!!p' | 
while read filename
	do 
		fulPath=$(pwd)/$filename;
		duration=$(ffmpeg -i "$(echo "$fulPath")" 2>&1 | grep Duration | cut -d ' ' -f 4 | sed s/,//); 
		text=$duration-$filename;
		seconds=$(echo $duration | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }');
		roundedSeconds=${seconds%.*};
		formattedDuration=$(printf "%02d" $(($roundedSeconds/86400)))"D "$(printf "%02d" $(($roundedSeconds%86400/3600)))"H "$(printf "%02d" $(($roundedSeconds%3600/60)))"M "$(printf "%02d" $(($roundedSeconds%60)))"S"
		start=$((start+roundedSeconds))
		fileCount=$((fileCount+1))
		formattedTotalDuration=$(printf "%02d" $(($start/86400)))"D "$(printf "%02d" $(($start%86400/3600)))"H "$(printf "%02d" $(($start%3600/60)))"M "$(printf "%02d" $(($start%60)))"S"

		echo $(printf "%04d" $fileCount)">T.D :"$formattedTotalDuration"	D :"$formattedDuration"	F :"$filename;
done
