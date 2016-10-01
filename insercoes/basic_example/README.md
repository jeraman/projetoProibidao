#Tutorial

This system is Linux-only and was tested in a Ubuntu 14.04. Let me know if you ever test this in another version/distribution, I'd love to know! 

*OBS:* For now on, there is no longer the need to configure Jack connections. There is now a python script that automates this process. 

##Dependencies
You will need the following software installed:
- [Youtube-dl](https://rg3.github.io/youtube-dl/); 

- [Ffmpeg](https://ffmpeg.org/) (compiled with Jack); 

- [V4l2loopback](https://github.com/umlaeute/v4l2loopback); 

- [Snd_aloop module] (https://www.alsa-project.org/main/index.php/Matrix:Module-aloop#The_module_options_for_snd-aloop);

- [Pd-extended](https://puredata.info) (hereafter, the Pd);

- [Jack](http://jackaudio.org/);

- [PyJack](http://jackclient-python.readthedocs.io).


##Process
The image below summarizes the process. After selecting your video target (picture (a)), you will process it locally on Pd (picture (b)), and then stream it back to youtube (picture (c)).

![Setup] (setup.png)

##Step 1
In the beginning, you need to choose the Youtube live stream video you want to target. This video is represented in the picture above by (a). Thus: 

> 1. Copy the URL of the target video;

##Step 2
Now we want to get this video inside Pd so that it can be processed locally. For this you need to:

> 2. Run the 'from_youtube_to_pd_via_jack.sh' script, passing the _copied URL_ and the _Pd patch_ (in this case, _"main.pd"_) as parameters;

> 3. *[Out of data. No need to do this. Kept for reference]* Modify the Jack patch, so that there are only two connections: a) from pd-extended to system; and b) from ffmpeg-output to pd-extended. As follows:

> ![Jack1] (jack1.png)


At this stage you will have the video modified in realtime by your Pd patch. This is represented by (b) in the image above. 

##Step 3
Finally, you need to:

> 3. Run the 'from_pd_to_youtube.sh' script, passing your live youtube video ID as parameter. In case you don't, the script will save the modified video in a local file;

> 4. *[Out of data. No need to do this. Kept for reference]* Modify the Jack patch, so that you add a connection from pd-extended to ffmpeg-input. The resulting Jack patch should look like this:

> ![Jack2] (jack2.png)

That's it! By now you should have the modified video streamed back to youtube—as shown in picture (c).

Have fun!

--
[Jeraman](https://jeraman.info), 2016.



