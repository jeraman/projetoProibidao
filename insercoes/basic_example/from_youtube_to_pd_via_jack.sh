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

echo
echo "***********************************"
echo " INSERCOES EM CIRCUITOS MEDIATICOS"
echo "***********************************" 
echo "     (cc) jeraman.info, 2016"
echo "***********************************"
echo

#wait a little bit
sleep 1

#verifying if parameters are well set
if [ -z "$VIDEO" ]; then
	echo "MISSING THE NAME OF THE VIDEO! EXITING..."
	exit 1
fi

if [ -z "$PATCH" ]; then
	echo "MISSING THE NAME OF THE PD PATCH! USING THE DEFAULT 'main.pd'..."
	PATCH=main.pd
fi

#stores the link for the stream
STREAM=$(youtube-dl -g --format mp4 $VIDEO)

#prints the link
echo
echo "link for the stream: $STREAM"
echo
echo "loading modules..."
echo

#waits this to complete
sleep 1

#loads the v4l2 module
sudo modprobe v4l2loopback

#waits this to complete
#sleep 2

#MAYBE THIS STEP IS DESNECESSARY WITH JACK!
#loads the sound loopback module
sudo modprobe snd-aloop pcm_substreams=1

echo
echo "starting jack server..."
echo


#waits this to complete
sleep 1

#starting jack
#sudo qjackctl -s -a=myPatchBay.xml &
sudo jackd -d alsa -r 44100 &

echo
echo "starting ffmpeg..."
echo

#waits a while to complete
sleep 2

#makes the magic happen!
sudo ffmpeg -re -loglevel quiet -thread_queue_size 4096 -r 30 -i $STREAM -preset ultrafast -aspect 16:9 -vf scale=1280:720 -vcodec rawvideo -pix_fmt yuv420p -f v4l2 $VIRTUAL_WEBCAM -f alsa -b:a 126k -ac 2 -ar 44100 $VIRTUAL_MIC &

#sudo ffmpeg -re -thread_queue_size 4096 -i $STREAM -isync -b:a 64k -ac 1 -ar 44100 -aspect 16:9 -vf scale=1280:720 -vcodec rawvideo -pix_fmt yuv420p -f v4l2 $VIRTUAL_WEBCAM -f alsa $VIRTUAL_MIC

#ffmpeg -thread_queue_size 2048 -i $STREAM -isync -ar 48100 -aspect 16:9 -vf scale=1280:720 -vcodec rawvideo -pix_fmt yuv420p -f v4l2 $VIRTUAL_WEBCAM -f alsa $VIRTUAL_MIC


#and finally loads puredata
echo
echo "starting puredata..."
echo

#waits a while to complete
sleep 4

#starting puredata
sudo pd-extended -rt -nogui -jack -open $PATCH &

#and setting up jack connections
echo
echo "setting up jack connections..."
echo

#waits a while to complete
sleep 5

#automatically adjusting jack connections
sudo python python/jack-script-youtube-to-pd.py 

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

#finishing jackd
sudo pkill pd-extended
sleep 1
sudo pkill ffmpeg
sleep 1
sudo pkill jackd
sudo pkill qjackctl
sleep 1
sudo pkill jackdbus

#clearing the screen
clear
