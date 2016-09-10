#!/bin/bash
#script that gets a live youtube video to pd.
#dependencies: youtube-dl; ffmpeg; v4l2loopback; and snd_aloop.

# IMPORTANT You can pkill pd-extended to stop this script.
#
#jeraman.info - 21 July 2016

#!/bin/bash
  
#stores the link for the video
VIDEO=$1   

#stores the pd patch that will be run
PATCH=$2

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

#MAYBE THIS STEP IS DESNECESSARY WITH JACK!
#loads the sound loopback module
sudo modprobe snd-aloop pcm_substreams=1

#waits this to complete
#sleep 2

echo
echo "starting jack server..."
echo

#starting jack
sudo qjackctl -s -a=myPatchBay.xml &
#sudo jackd -r -d alsa -r 44100 &

#waits a while to complete
sleep 2

echo
echo "starting ffmpeg..."
echo

#makes the magic happen!
sudo ffmpeg -re -loglevel quiet -thread_queue_size 2048 -r 30 -i $STREAM -preset ultrafast -aspect 16:9 -vf scale=1280:720 -vcodec rawvideo -pix_fmt yuv420p -f v4l2 $VIRTUAL_WEBCAM -f alsa -b:a 64k -ac 2 -ar 44100 $VIRTUAL_MIC &

#sudo ffmpeg -re -loglevel quiet -thread_queue_size 4096 -r 30 -i $STREAM -preset ultrafast -aspect 16:9 -vf scale=1280:720 -vcodec rawvideo -pix_fmt yuv420p -f v4l2 $VIRTUAL_WEBCAM -f alsa -b:a 126k -ac 2 -ar 44100 $VIRTUAL_MIC &

#sudo ffmpeg -re -thread_queue_size 4096 -i $STREAM -isync -b:a 64k -ac 1 -ar 44100 -aspect 16:9 -vf scale=1280:720 -vcodec rawvideo -pix_fmt yuv420p -f v4l2 $VIRTUAL_WEBCAM -f alsa $VIRTUAL_MIC

#ffmpeg -thread_queue_size 2048 -i $STREAM -isync -ar 48100 -aspect 16:9 -vf scale=1280:720 -vcodec rawvideo -pix_fmt yuv420p -f v4l2 $VIRTUAL_WEBCAM -f alsa $VIRTUAL_MIC

#waits a while to complete
sleep 4

#and finally loads puredata
echo
echo "starting puredata..."
echo

#starting puredata
#sudo pd-extended -jack -open testing-signal-from-youtube.pd
sudo pd-extended -rt -jack -open $PATCH

#waits a while to complete
sleep 2

#kills all processes when key is pressed
#echo
#echo "press any key to kill all processes used in this script"
#echo

#read -n 1

#finishing jackd
sudo pkill pd-extended
sleep 1
sudo pkill ffmpeg
sleep 1
#sudo pkill jackd
sudo pkill qjackctl
sleep 1
sudo pkill qjackdbus

#clearing the screen
clear
