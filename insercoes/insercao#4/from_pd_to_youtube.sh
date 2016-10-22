#!/bin/bash
#script that gets one active window in the operating system and streams it to youtube live
#dependencies: ffmpeg.
#
# IMPORTANT: YOU NEED TO RUN THIS AS './SCRIPT' and not 'sh SCRIPT'. if you do, you willl get 'bad substitution'. 
#
#jeraman.info - 21 July 2016

#stores the youtube ID
ID=$1

echo
echo "***********************************"
echo " INSERCOES EM CIRCUITOS MEDIATICOS"
echo "***********************************" 
echo "     (cc) jeraman.info, 2016"
echo "***********************************"
echo

#wait a little bit
sleep 1


#asks the user to select the area he wants to stream
echo
echo "select the window you want to cast"
echo

unset X Y WIDTH HEIGHT
  eval $(xwininfo |
    sed -n -e "s/^ \+Absolute upper-left X: \+\([0-9]\+\).*/X=\1/p" \
           -e "s/^ \+Absolute upper-left Y: \+\([0-9]\+\).*/Y=\1/p" \
           -e "s/^ \+Width: \+\([0-9]\+\).*/WIDTH=\1/p" \
           -e "s/^ \+Height: \+\([0-9]\+\).*/HEIGHT=\1/p" )
  echo -n "$X $Y $WIDTH $HEIGHT"



#gets the raw position
#RAW_POSITION=$(xwininfo | grep geometry)
#echo "RAW_POSITION: $RAW_POSITION"

#extracts substring
#POSITION=${RAW_POSITION:12}
#echo "POSITION: $POSITION"

#extracting the width
#IFS='x' read -r -a TEMP1 <<< "$POSITION"
#WIDTH=${TEMP1[0]}
#WIDTH=$((WIDTH-8))

#replaces '-' by '+'
#NO_MINUS=$(echo "${TEMP1[1]}" | tr - +)

#extracting the remaining info
#IFS='+' read -r -a TEMP2 <<< "${NO_MINUS}"

#extracting height
#HEIGHT=${TEMP2[0]}
#HEIGHT=$((HEIGHT-4))

#extracting x coord and shifting value
#X=${TEMP2[1]}
#X=$((X+14))

#extracing y coord and shifting value
#Y=${TEMP2[2]}
#Y=$((Y+40))

#making WIDTH even,if not (limitation from ffmpeg)
[ $((WIDTH%2)) -eq 1 ] && echo "make WIDTH even!" && WIDTH=$((WIDTH+1))

#making HEIGHT even, if not (limitation from ffmpeg)
[ $((HEIGHT%2)) -eq 1 ] && echo "make WIDTH even!" && HEIGHT=$((HEIGHT+1))

#printing window info
echo
echo
echo "WIDTH: $WIDTH"
echo "HEIGHT: $HEIGHT"
echo "X: $X"
echo "Y: $Y"
echo
echo "starting the streaming..."
echo

#adjusting to take the borders off
#WIDTH=$((WIDTH-10))
#HEIGHT=$((HEIGHT-10))

#init variable
CMD=""

#if no id was passed
if [ -z "$ID" ]; then
	echo "MISSING THE YOUTUBE LIVE ID. USING A LOCAL FILE INSTEAD..."

	#using ffmpeg with localfile
	CMD="sudo ffmpeg -re -loglevel quiet -thread_queue_size 2048 -f alsa -i jack -f x11grab -framerate 30 -video_size ${WIDTH}x${HEIGHT} -i :0.0+${X},${Y} -vcodec libx264 -preset veryfast -crf 18 -maxrate 1984k -bufsize 3968k -pix_fmt yuv420p -g 60 -acodec libmp3lame -ar 44100 test.mp4" 

	sudo rm test.mp4

#if the id was passed
else
	echo "ID OK. USING YOUTUBE LIVE..."

	#format the command - trying to make ffmpeg faster
	CMD="sudo ffmpeg -re -loglevel quiet -thread_queue_size 2048 -f alsa -i jack -f x11grab -framerate 30 -video_size ${WIDTH}x${HEIGHT} -i :0.0+${X},${Y} -vcodec libx264 -preset ultrafast -pix_fmt yuv420p -acodec libmp3lame -ar 44100 -f flv rtmp://a.rtmp.youtube.com/live2/$ID"

fi

echo
echo
sleep 2

#print and execute the command
echo $CMD
$CMD &

#and setting up jack connections
echo
echo "setting up jack connections..."
echo

sleep 3

#waits a while to complete

#automatically adjusting jack connections
sudo python python/jack-script-pd-to-youtube.py 

sleep 5

#kills all processes if 'q' is pressed
echo
echo "*************************************************************"
echo "READY TO GO! MODIFICATION IN PROGRESS... PRESS 'q' TO STOP!"
echo "*************************************************************"
echo

while :
do
    read -t 1 -n 1 key

    if [[ $key = q ]]
    then
        break
    fi
done

echo
echo "stopping the process..."
echo

#finishing ffmpeg
sleep 1
sudo pkill ffmpeg

clear



