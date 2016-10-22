#Tutorial

This system is Linux-only and was tested in a Ubuntu 14.04. Let me know if you ever test this in another version/distribution, I'd love to know! 

*OBS:* For now on, there is no longer the need to configure Jack connections. There is now a python script that automates this process. 

##Dependencies & pre-setup
You will need the following software installed:
- [Youtube-dl](https://rg3.github.io/youtube-dl/); 

- [Ffmpeg](https://ffmpeg.org/) (compiled with Jack); 

- [V4l2loopback](https://github.com/umlaeute/v4l2loopback); 

- [Snd_aloop module] (https://www.alsa-project.org/main/index.php/Matrix:Module-aloop#The_module_options_for_snd-aloop);

- [Pd-extended](https://puredata.info) (hereafter, the Pd);

- [Jack](http://jackaudio.org/);

- [PyJack](http://jackclient-python.readthedocs.io).

In addition to installing all dependencies, you will need to configure the loopback device to work with Jack. Some detailed instructions are available [here] (http://jackaudio.org/faq/routing_alsa.html). In short:

> This approach "requires an ALSA “plugin” that is not installed by default on many Linux distributions, and the name of the package containing it will vary from distribution to distribution. On Fedora, the package is called “alsa-plugins- jack”; on some Debian-related systems, it can be found in “libasound2-plugins”. You should install this using your system’s normal software install/update tool(s).

> Once you have it installed, you can use it by editing the file ~/.asoundrc (this file may not exist when you start this, or it may already have some content). You need to add the following text to it:

```
pcm.rawjack {
    type jack
    playback_ports {
        0 system:playback_1
        1 system:playback_2
    }
    capture_ports {
        0 system:capture_1
        1 system:capture_2
    }
}

pcm.jack {
    type plug
    slave { pcm "rawjack" }
    hint {
 	description "JACK Audio Connection Kit"
    }
}
```

> Having done this, you can now use the name “pcm.jack” when using any application that allows you to specify a device name (which in theory all ALSA applications are supposed to do). The simplest test case to make sure that things work is to use the ALSA aplay utility like this:"

```
aplay -D pcm.jack /path/to/some/non-compressed/audio/file
```

##Process
The image below summarizes the process. After selecting your video target (picture (a)), you will process it locally on Pd (picture (b)), and then stream it back to youtube (picture (c)).

![Setup] (setup.png)

##Step 1
In the beginning, you need to choose the Youtube live stream video you want to target. This video is represented in the picture above by (a). Thus: 

> 1. Copy the URL of the target video;

##Step 2
Now we want to get this video inside Pd so that it can be processed locally. For this you need to run the 'from_youtube_to_pd_via_jack.sh' script, passing the _copied URL_ and the _Pd patch_ (in this case, _"main.pd"_) as parameters, as follows:


```
sudo ./from_youtube_to_pd_via_jack.sh (YOUTUBE_URL) (PD_PATCH)
```

At this stage you will have the video modified in realtime by your Pd patch. This is represented by (b) in the image above. 

##Step 3
Finally, you need to run the 'from_pd_to_youtube.sh' script, passing your live youtube video ID as parameter. In case you don't, the script will save the modified video in a local file, as follows:

```
sudo ./from_pd_to_youtube.sh (YOUTUBE_ID) 
```

That's it! By now you should have the modified video streamed back to youtube—as shown in picture (c).

Have fun!

--
[Jeraman](https://jeraman.info), 2016.



