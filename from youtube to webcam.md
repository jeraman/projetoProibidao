
#Step 1: From a youtube video to ffmpeg

###example (TV senado, from Brazil):
youtube-dl -g --format mp4 https://www.youtube.com/watch?v=lHIL4OzHwzU

###results in the URL for the video file itself. for example: 
https://manifest.googlevideo.com/api/manifest/hls_playlist/id/lHIL4OzHwzU.1/itag/94/source/yt_live_broadcast/requiressl/yes/ratebypass/yes/live/1/cmbypass/yes/goi/160/sgoap/itag%3D140/sgovp/itag%3D135/hls_chunk_host/r1---sn-gpn9-t0al.googlevideo.com/gcr/ca/playlist_type/DVR/mpr/1250000/mm/32/mn/sn-gpn9-t0al/ms/lv/mv/m/pl/21/dover/3/fexp/9405960,9416126,9416891,9419451,9422596,9428398,9429745,9431012,9432363,9433096,9433380,9433946,9434709,9435361,9435400,9435490,9435526,9435876,9436607,9436835,9436986,9437066,9437285,9437552,9437742,9437898,9438326,9438332,9439365,9439616,9439652,9440158/sver/3/upn/PkYjV9LB2ew/mt/1467211520/ip/132.206.14.226/ipbits/0/expire/1467233191/sparams/ip,ipbits,expire,id,itag,source,requiressl,ratebypass,live,cmbypass,goi,sgoap,sgovp,hls_chunk_host,gcr,playlist_type,mpr,mm,mn,ms,mv,pl/signature/850F3DF9CA3152AD5504DA6B4B8AEE05B49CF085.093141E8C67973F95006605F6987A4A75795AD4D/key/dg_yt0/playlist/index.m3u8

###all you need now is to play this file
ffplay “link provided by youtube dl”

###references
https://stefansundin.com/blog/452

https://github.com/rg3/youtube-dl

http://comments.gmane.org/gmane.comp.video.ffmpeg.user/54861


#Step 2: From ffmpeg to a webcam (video)

###loads the module
sudo modprobe v4l2loopback

###streams to the file to the virtual webcam
sudo ffmpeg -re -i MOVIE_FILE -vcodec rawvideo -pix_fmt yuv420p v4l2 YOUR_VIRTUAL_WEBCAM

###getting from the youtube to the webcam
sudo ffmpeg -re -i https://manifest.googlevideo.com/api/manifest/hls_playlist/id/lHIL4OzHwzU.1/itag/94/source/yt_live_broadcast/requiressl/yes/ratebypass/yes/live/1/cmbypass/yes/goi/160/sgoap/itag%3D140/sgovp/itag%3D135/hls_chunk_host/r1---sn-cxaaj5o5q5-t0as.googlevideo.com/gcr/ca/playlist_type/DVR/mm/32/mn/sn-cxaaj5o5q5-t0as/ms/lv/mv/m/pl/22/dover/3/sver/3/upn/rqqdPgEJDPE/fexp/9405989,9407155,9416126,9416891,9419452,9420096,9422596,9427767,9428398,9431012,9433096,9433380,9433850,9433946,9435241,9435526,9435876,9436607,9436841,9437066,9437552,9437742,9437982,9438519,9438557,9438733,9439442,9439652,9439811/mt/1467235816/ip/65.94.85.86/ipbits/0/expire/1467257491/sparams/ip,ipbits,expire,id,itag,source,requiressl,ratebypass,live,cmbypass,goi,sgoap,sgovp,hls_chunk_host,gcr,playlist_type,mm,mn,ms,mv,pl/signature/120EFCFB10B3093EB14D58C1BA85DE281DDE0F80.8D13202941DE0F06D19FEBA6CC8426A38AAAAE6D/key/dg_yt0/playlist/index.m3u8 -vcodec rawvideo -pix_fmt yuv420p -f v4l2 /dev/video1

###references
https://github.com/umlaeute/v4l2loopback/

https://github.com/umlaeute/v4l2loopback/wiki/Ffmpeg


#Step 3: From ffmpeg to a micrphone (audio)

###... plus playing back the audio from the stream
sudo ffmpeg -re -i https://manifest.googlevideo.com/api/manifest/hls_playlist/id/lHIL4OzHwzU.1/itag/94/source/yt_live_broadcast/requiressl/yes/ratebypass/yes/live/1/cmbypass/yes/goi/160/sgoap/itag%3D140/sgovp/itag%3D135/hls_chunk_host/r1---sn-cxaaj5o5q5-t0as.googlevideo.com/gcr/ca/playlist_type/DVR/mm/32/mn/sn-cxaaj5o5q5-t0as/ms/lv/mv/m/pl/22/dover/3/sver/3/upn/rqqdPgEJDPE/fexp/9405989,9407155,9416126,9416891,9419452,9420096,9422596,9427767,9428398,9431012,9433096,9433380,9433850,9433946,9435241,9435526,9435876,9436607,9436841,9437066,9437552,9437742,9437982,9438519,9438557,9438733,9439442,9439652,9439811/mt/1467235816/ip/65.94.85.86/ipbits/0/expire/1467257491/sparams/ip,ipbits,expire,id,itag,source,requiressl,ratebypass,live,cmbypass,goi,sgoap,sgovp,hls_chunk_host,gcr,playlist_type,mm,mn,ms,mv,pl/signature/120EFCFB10B3093EB14D58C1BA85DE281DDE0F80.8D13202941DE0F06D19FEBA6CC8426A38AAAAE6D/key/dg_yt0/playlist/index.m3u8 -vcodec rawvideo -pix_fmt yuv420p -f v4l2 /dev/video1 -f alsa default

###references
???

===

#question
- How do we route the audio to a virtual mic?

-- 
Jeronimo Barbosa
jeraman.info
