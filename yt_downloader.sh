#!/bin/sh
##############################Important###########################################
#If error occurs for urlencode , just install the library using following command:
# sudo apt-get install gridsite-clients


#Number of safe duplicates for a single video which can exist, practically correct , theoreticlly should be infinite value which is little more intensive to implement in for loop but not impossible
NUM_LIMIT=10000

url=$1
st_time=$2
dur=$3

#If no duration is given just by default assume its 10 seconds
if [ -z "$dur" ]
then
      dur=10
fi


vid_id=$(cut -f 2 -d '=' <<< $url)
vid_id=$(echo $vid_id | tr '-' '_')
video="$vid_id".mkv""

#if [ -f $video ]; then
#   echo "File $video exists."
#   for i in `seq 1 $NUM_LIMIT`;
#    do 
#	video="$vid_id""_VID_""$i".mkv""
#	if [ -f $video ]; then
#	  continue   #Repeated video exists so continue the loop again	
#	else
#	  break      #This video name doesnot exist so break out of loop and new video will be named by this name   
#	fi   
#   done;  
#fi

#Extrcation done using quvi and JSON parser
#link=$(quvi $url | jq -r '.link[0].url')
link_en=$(quvi dump -p json $url | jq -r '.quvi.media.stream.QUVI_MEDIA_STREAM_PROPERTY_URL')
link=$(urlencode -d $link_en)
ffmpeg -ss $st_time -t $dur -i "$link" $video 

if [ ! -f $video ]; then
    echo "Problem with URL(Forbidden error 403)!!,Getting new link"
    # Extraction done using youtube-dl 
    link=$(youtube-dl -g $url)


    ffmpeg -ss $st_time -t $dur -i "$link" $video
fi

