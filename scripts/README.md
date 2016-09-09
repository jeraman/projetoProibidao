#Step-by-step tutorial

The image below summarizes the process. After selecting your video target (picture (a)), you will process it locally on Pd (picture (b)), and then stream it back to youtube (picture (c)).
![Setup] (setup.png)

##Step 1
In the beginning, you need to choose the Youtube live stream video you want to target. This video is represented in the picture above by (a). Thus: 

1. Copy the URL of the target video;

##Step 2
Now we want to get this video inside Pd so that it can be processed locally. For this you need to:

2. Run the 'from_youtube_to_pd.sh' script, passing the copied URL as parameter;

3. Modify the Jack patch, so that there are only two connections: a) from pd-extended to system; and b) from ffmpeg-ouput to pd-extended;


At this stage you will have the video modified in realtime by your Pd patch. This is represented by (b) in the image above. 

##Step 3
Finally, you need to:

3. Run the 'from_pd_to_youtube.sh' script, passing your live youtube video ID as parameter;

4. Modify the Jack patch, so that you add a connection from pd-extended to ffmpeg-input. The resulting Jack patch should look like this:

![Jack] (jack-connections.png)

That's it! By now you should have the modified video streamed back to youtube—as shown in picture (c). Have fun!



