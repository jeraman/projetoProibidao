#!/bin/bash
#script that gets a live youtube video to pd.
#dependencies: youtube-dl; ffmpeg; v4l2loopback; and snd_aloop.
#jeraman.info - 21 July 2016

#!/bin/bash
  
#stores the link for the video
VIDEO=$1   

#stores the address for the virtual webcam
VIRTUAL_WEBCAM=/dev/video1   

#stores the address for the virtual mic
#VIRTUAL_MIC=hw:Loopback,1,0
VIRTUAL_MIC=pcm.jack
#VIRTUAL_MIC=pcm.default
#VIRTUAL_MIC=pcm.aduplex

#stores the link for the stream
STREAM=$(youtube-dl -g --format mp4 $VIDEO)

#waits this to complete
#sleep 3

#prints the link
echo
echo "Link for the stream: $STREAM"
echo
echo "Loading modules..."
echo

#loads the v4l2 module
sudo modprobe v4l2loopback

#waits this to complete
#sleep 2

#loads the sound loopback module
sudo modprobe snd-aloop pcm_substreams=1

#waits this to complete
#sleep 2

echo
echo "starting..."
echo

#makes the magic happen!
sudo ffmpeg -re -thread_queue_size 4096 -r 30 -i $STREAM -preset ultrafast -aspect 16:9 -vf scale=1280:720 -vcodec rawvideo -pix_fmt yuv420p -f v4l2 $VIRTUAL_WEBCAM -f alsa -b:a 126k -ac 2 -ar 44100 $VIRTUAL_MIC

#sudo ffmpeg -re -thread_queue_size 4096 -i $STREAM -isync -b:a 64k -ac 1 -ar 44100 -aspect 16:9 -vf scale=1280:720 -vcodec rawvideo -pix_fmt yuv420p -f v4l2 $VIRTUAL_WEBCAM -f alsa $VIRTUAL_MIC

#ffmpeg -thread_queue_size 2048 -i $STREAM -isync -ar 48100 -aspect 16:9 -vf scale=1280:720 -vcodec rawvideo -pix_fmt yuv420p -f v4l2 $VIRTUAL_WEBCAM -f alsa $VIRTUAL_MIC
