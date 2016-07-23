#!/bin/bash
#script that gets one active window in the operating system and streams it to youtube live
#dependencies: ffmpeg.
#
#jeraman.info - 21 July 2016

#stores the youtube ID
ID=$1

#asks the user to select the area he wants to stream
echo
echo "select the window you want to cast"
echo
RAW_POSITION=$(xwininfo | grep geometry)

#extracts substring
POSITION=${RAW_POSITION:12}
echo "POSITION: $POSITION"

#extracting the width
IFS='x' read -r -a TEMP1 <<< "$POSITION"
WIDTH=${TEMP1[0]}
WIDTH=$((WIDTH-8))

#making WIDTH even,if not (limitation from ffmpeg)
[ $((WIDTH%2)) -eq 1 ] && echo "make WIDTH even!" && WIDTH=$((WIDTH+1))

#replaces '-' by '+'
NO_MINUS=$(echo "${TEMP1[1]}" | tr - +)

#extracting the remaining info
IFS='+' read -r -a TEMP2 <<< "${NO_MINUS}"

#TEMP2=${TEMP2[@]/""}
#for i in $TEMP2; do
#  [${TEMP2[$i]} -eq ""] && unset ${TEMP2[$i]} && echo "ae!"
#done



#extracting height
HEIGHT=${TEMP2[0]}
HEIGHT=$((HEIGHT-4))


#making HEIGHT even, if not (limitation from ffmpeg)
[ $((HEIGHT%2)) -eq 1 ] && echo "make WIDTH even!" && HEIGHT=$((HEIGHT+1))

#extracting x coord and shifting value
X=${TEMP2[1]}
X=$((X+14))

#extracing y coord and shifting value
Y=${TEMP2[2]}
Y=$((Y+40))

#printing window info
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


#execute the command
#sudo ffmpeg -thread_queue_size 512 -f alsa -i hw:0 -f x11grab -framerate 25 -video_size ${WIDTH}x${HEIGHT} -i :0.0+${X},${Y} -vcodec libx264 -preset veryfast -crf 18 -maxrate 1984k -bufsize 3968k -pix_fmt yuv420p -g 60 -acodec libmp3lame -ar 44100 test.mp4

#-f flv rtmp://a.rtmp.youtube.com/live2/$ID

#format the command
CMD="sudo ffmpeg -thread_queue_size 512 -f alsa -i hw:0 -f x11grab -framerate 25 -video_size ${WIDTH}x${HEIGHT} -i :0.0+${X},${Y} -vcodec libx264 -preset veryfast -crf 18 -maxrate 1984k -bufsize 3968k -pix_fmt yuv420p -g 60 -acodec libmp3lame -ar 44100 -f flv rtmp://a.rtmp.youtube.com/live2/$ID"

#print and execute the command
echo $CMD
$CMD




