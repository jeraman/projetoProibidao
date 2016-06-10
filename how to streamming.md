# reference:
https://weblog.lkiesow.de/20160215-raspberry-pi-screen-mirroring/

# ffmpeg audio & video screen capture 
### in linux
ffmpeg -thread_queue_size 512 -f alsa -i pulse -r 25 -f x11grab -s 1280x720 -i :0.0 -c:v libx264 -pix_fmt yuv420p -preset ultrafast -b:v 1000k -bufsize 500k -b:a 128k -ac 1 -ar 44100 -af volume=20 -f mpegts udp://RASPBERRY_IP:8888

### in mac (video not working)
ffmpeg -f avfoundation -pixel_format yuv420p -r 30 -i "1:1" -vcodec libx264 -preset veryfast -tune zerolatency -bsf:v h264_mp4toannexb -b:v 5000k -bufsize 500k -f mpegts udp://RASPBERRY_IP_:8888

# playing data in raspberry pi
omxplayer udp://0.0.0.0:8888

#challenges & to do 
- speed up enconding in server so that speed remains above 1;
- play around with ffmpeg parameters in order to improve quality and reduce cpu load;
- test reliability for the long-term;
- record a video demo and upload that in youtube;