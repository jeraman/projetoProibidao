
#Step 1: From a youtube video to ffmpeg

###example (TV senado, from Brazil):
youtube-dl -g --format mp4 https://www.youtube.com/watch?v=lHIL4OzHwzU

###results in the URL for the video file itself. for example: 
```
https://manifest.googlevideo.com/api/manifest/hls_playlist/id/lHIL4OzHwzU.1/itag/94/source/yt_live_broadcast/requiressl/yes/ratebypass/yes/live/1/cmbypass/yes/goi/160/sgoap/itag%3D140/sgovp/itag%3D135/hls_chunk_host/r1---sn-gpn9-t0al.googlevideo.com/gcr/ca/playlist_type/DVR/mpr/1250000/mm/32/mn/sn-gpn9-t0al/ms/lv/mv/m/pl/21/dover/3/fexp/9405960,9416126,9416891,9419451,9422596,9428398,9429745,9431012,9432363,9433096,9433380,9433946,9434709,9435361,9435400,9435490,9435526,9435876,9436607,9436835,9436986,9437066,9437285,9437552,9437742,9437898,9438326,9438332,9439365,9439616,9439652,9440158/sver/3/upn/PkYjV9LB2ew/mt/1467211520/ip/132.206.14.226/ipbits/0/expire/1467233191/sparams/ip,ipbits,expire,id,itag,source,requiressl,ratebypass,live,cmbypass,goi,sgoap,sgovp,hls_chunk_host,gcr,playlist_type,mpr,mm,mn,ms,mv,pl/signature/850F3DF9CA3152AD5504DA6B4B8AEE05B49CF085.093141E8C67973F95006605F6987A4A75795AD4D/key/dg_yt0/playlist/index.m3u8
```

###all you need now is to play this file
ffplay “link provided by youtube dl”

###references
https://stefansundin.com/blog/452

https://github.com/rg3/youtube-dl

http://comments.gmane.org/gmane.comp.video.ffmpeg.user/54861


#Step 2: From ffmpeg to a webcam (video)

###loads the video loopback module
sudo modprobe v4l2loopback

###streams to the file to the virtual webcam
sudo ffmpeg -re -i MOVIE_FILE -vcodec rawvideo -pix_fmt yuv420p v4l2 YOUR_VIRTUAL_WEBCAM

###getting from the youtube to the webcam
```
sudo ffmpeg -re -i https://manifest.googlevideo.com/api/manifest/hls_playlist/id/lHIL4OzHwzU.1/itag/94/source/yt_live_broadcast/requiressl/yes/ratebypass/yes/live/1/cmbypass/yes/goi/160/sgoap/itag%3D140/sgovp/itag%3D135/hls_chunk_host/r1---sn-cxaaj5o5q5-t0as.googlevideo.com/gcr/ca/playlist_type/DVR/mm/32/mn/sn-cxaaj5o5q5-t0as/ms/lv/mv/m/pl/22/dover/3/sver/3/upn/rqqdPgEJDPE/fexp/9405989,9407155,9416126,9416891,9419452,9420096,9422596,9427767,9428398,9431012,9433096,9433380,9433850,9433946,9435241,9435526,9435876,9436607,9436841,9437066,9437552,9437742,9437982,9438519,9438557,9438733,9439442,9439652,9439811/mt/1467235816/ip/65.94.85.86/ipbits/0/expire/1467257491/sparams/ip,ipbits,expire,id,itag,source,requiressl,ratebypass,live,cmbypass,goi,sgoap,sgovp,hls_chunk_host,gcr,playlist_type,mm,mn,ms,mv,pl/signature/120EFCFB10B3093EB14D58C1BA85DE281DDE0F80.8D13202941DE0F06D19FEBA6CC8426A38AAAAE6D/key/dg_yt0/playlist/index.m3u8 -vcodec rawvideo -pix_fmt yuv420p -f v4l2 /dev/video1
```

###references
https://github.com/umlaeute/v4l2loopback/

https://github.com/umlaeute/v4l2loopback/wiki/Ffmpeg


#Step 3: From ffmpeg to a microphone (audio)

###testing if the audio is being captured all right from the video stream
```
sudo ffmpeg -re -i https://manifest.googlevideo.com/api/manifest/hls_playlist/id/lHIL4OzHwzU.1/itag/94/source/yt_live_broadcast/requiressl/yes/ratebypass/yes/live/1/cmbypass/yes/goi/160/sgoap/itag%3D140/sgovp/itag%3D135/hls_chunk_host/r1---sn-cxaaj5o5q5-t0as.googlevideo.com/gcr/ca/playlist_type/DVR/mm/32/mn/sn-cxaaj5o5q5-t0as/ms/lv/mv/m/pl/22/dover/3/sver/3/upn/rqqdPgEJDPE/fexp/9405989,9407155,9416126,9416891,9419452,9420096,9422596,9427767,9428398,9431012,9433096,9433380,9433850,9433946,9435241,9435526,9435876,9436607,9436841,9437066,9437552,9437742,9437982,9438519,9438557,9438733,9439442,9439652,9439811/mt/1467235816/ip/65.94.85.86/ipbits/0/expire/1467257491/sparams/ip,ipbits,expire,id,itag,source,requiressl,ratebypass,live,cmbypass,goi,sgoap,sgovp,hls_chunk_host,gcr,playlist_type,mm,mn,ms,mv,pl/signature/120EFCFB10B3093EB14D58C1BA85DE281DDE0F80.8D13202941DE0F06D19FEBA6CC8426A38AAAAE6D/key/dg_yt0/playlist/index.m3u8 -vcodec rawvideo -pix_fmt yuv420p -f v4l2 /dev/video1 -f alsa default
```

###loads the sound loopback module
modprobe snd-aloop pcm_substreams=1

###create a ~/.asoundrc file and copy and paste this content (can be improved?)
```
# .asoundrc
pcm.!default {
	type hw
	card 0
} 

pcm.loopin {
	type plug
	slave.pcm "hw:Loopback,0,0"
}

pcm.loopout {
	type plug
	slave.pcm "hw:Loopback,1,0"
}
```

###updating the ffmpeg code to include audio and video
```
sudo ffmpeg -re -thread_queue_size 1024 -i https://manifest.googlevideo.com/api/manifest/hls_playlist/id/AHSmzcGnTFg.1/itag/94/source/yt_live_broadcast/requiressl/yes/ratebypass/yes/live/1/cmbypass/yes/goi/160/sgoap/itag%3D140/sgovp/itag%3D135/hls_chunk_host/r8---sn-cxaaj5o5q5-t0ae.googlevideo.com/playlist_type/DVR/gcr/ca/mm/32/mn/sn-cxaaj5o5q5-t0ae/ms/lv/mv/u/pcm2cms/yes/pl/22/dover/3/sver/3/fexp/9405186,9405995,9416126,9416891,9419452,9422596,9425620,9428398,9431012,9433096,9433223,9433425,9433946,9434904,9434904,9435526,9435876,9437066,9437262,9437553,9437742,9438227,9438663,9438816,9439124,9439185,9439412,9439497,9439652,9439828,9441086,9441560,9441716/upn/loCLjutR-iw/mt/1468508049/ip/65.94.85.86/ipbits/0/expire/1468530401/sparams/ip,ipbits,expire,id,itag,source,requiressl,ratebypass,live,cmbypass,goi,sgoap,sgovp,hls_chunk_host,playlist_type,gcr,mm,mn,ms,mv,pcm2cms,pl/signature/30CBE22045D5984D983F9949BFD4D0D56808EC1A.493BBF5F2CF4263DD90F49964550EB3DE6447686/key/dg_yt0/playlist/index.m3u8 -ar 48100 -async 1 -vcodec rawvideo -pix_fmt yuv420p -f v4l2 /dev/video1 -f alsa hw:Loopback,1,0
```

###Voila!
It should be working now! Video should be your second webcam. If you want to use the mic, don't forget to change the default input for the Loopback device.

###references
https://trac.ffmpeg.org/wiki/Capture/ALSA

http://www.alsa-project.org/main/index.php/Asoundrc

#Step 4: From mic & webcam to Pd
Nothing special. Just use the webcam (GEM) and your mic (adc~) as usual.

#Step 5: From Pd to Youtube

###testing screencast with mic to youtube live
Similar to "[screencapture over network.md](https://github.com/jeraman/projetoProibidao/blob/master/screencapture%20over%20network.md)". The difference is that you need to replace to ip in the end by the Youtube's live's Rmtp and to insert your unique ID. As follows:
```
sudo ffmpeg -thread_queue_size 512 -f alsa -i hw:0 -f x11grab -framerate 25 -video_size 1280x720 -i :0.0+0,0 -vcodec libx264 -preset veryfast -crf 18 -maxrate 1984k -bufsize 3968k -pix_fmt yuv420p -g 60 -acodec libmp3lame -b:a 128k -ar 44100 -f flv rtmp://a.rtmp.youtube.com/live2/ID
```
results in [this](https://www.youtube.com/watch?v=TRvnPGPc15Q).

###putting it all together!
results in [this](https://www.youtube.com/watch?v=mxL786aV-6U).


===

#question
- [Step 2] How to avoid the video and the audio to stop from times to times. It runs fine if I use ffplay. How to fix this?
- [Step 3] Audio is low quality (possibly due to the audio loopback). This doesn't happen in ffplay. How to fix this?
- [Step 3] Audio is getting out-of-sync with the video after some seconds. How to fix this?
- [Step 5] How to get only the audio from Pd direct into youtube?

-- 
Jeronimo Barbosa
jeraman.info
