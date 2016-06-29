

#########################################
# GETTING THE YOUTUBE VIDEO TO FFMPEG
##########################################

REFERENCE 1: https://stefansundin.com/blog/452

REFERENCE 2: https://github.com/rg3/youtube-dl

REFERENCE 3: http://comments.gmane.org/gmane.comp.video.ffmpeg.user/54861

#example for the brazlian TV send.
youtube-dl -g --format mp4 https://www.youtube.com/watch?v=lHIL4OzHwzU

#this will result in the URL for the video file itself. for example: 
https://manifest.googlevideo.com/api/manifest/hls_playlist/id/lHIL4OzHwzU.1/itag/94/source/yt_live_broadcast/requiressl/yes/ratebypass/yes/live/1/cmbypass/yes/goi/160/sgoap/itag%3D140/sgovp/itag%3D135/hls_chunk_host/r1---sn-gpn9-t0al.googlevideo.com/gcr/ca/playlist_type/DVR/mpr/1250000/mm/32/mn/sn-gpn9-t0al/ms/lv/mv/m/pl/21/dover/3/fexp/9405960,9416126,9416891,9419451,9422596,9428398,9429745,9431012,9432363,9433096,9433380,9433946,9434709,9435361,9435400,9435490,9435526,9435876,9436607,9436835,9436986,9437066,9437285,9437552,9437742,9437898,9438326,9438332,9439365,9439616,9439652,9440158/sver/3/upn/PkYjV9LB2ew/mt/1467211520/ip/132.206.14.226/ipbits/0/expire/1467233191/sparams/ip,ipbits,expire,id,itag,source,requiressl,ratebypass,live,cmbypass,goi,sgoap,sgovp,hls_chunk_host,gcr,playlist_type,mpr,mm,mn,ms,mv,pl/signature/850F3DF9CA3152AD5504DA6B4B8AEE05B49CF085.093141E8C67973F95006605F6987A4A75795AD4D/key/dg_yt0/playlist/index.m3u8

#all you need now is to play this file
ffplay “link provided by youtube dl”


#########################################
# from ffmpeg to webcam in linux
#########################################

REFERENCE 1: https://github.com/umlaeute/v4l2loopback/

REFERENCE 2: https://github.com/umlaeute/v4l2loopback/wiki/Ffmpeg

#loads the module
sudo modprobe v4l2loopback

#streams to the file to the virtual webcam
sudo ffmpeg -re -i MOVIE_FILE -vcodec rawvideo -pix_fmt yuv420p v4l2 YOUR_VIRTUAL_WEBCAM