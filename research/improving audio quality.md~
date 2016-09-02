#Improving audio quality
Audio is low quality (possibly due to the audio loopback). This doesn't happen in ffplay. How to fix this?

##Before starting...
1. Make sure you test in a local file before trying to live stream. replace the last line by:
test.mp4

2. Make sure the sound is working properly!

#Problem 1
The hw:Loopback works fine in Audacity. However, everytime we load the snd_aloop module, pd-extended starts behaving weird. Audio quality is terrible, even for the audio basic test.

##Solution 1
Route the audio directly to jack, and then to pd.

1. Make sure you have the right ~/.asoundrd file as follows:
'''
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
'''
2. Open Jack;

3. Play a audio file directly to jack by using:
'''
aplay -D pcm.jack audiodata/base1.wav
'''

If the audio plays and you can see a new Jack input, you shoud good to go!


4. Test if jack is available to you by doing:
'''
aplay -L | grep jack
'''

###Drawback
This alternative works, but the audio is always repeating. not usable.

###References
####the simple approach
http://jackaudio.org/faq/routing_alsa.html

####the most ocmplex approach
http://alsa.opensrc.org/Jack_and_Loopback_device_as_Alsa-to-Jack_bridge

####detailing the .asoundrc file
http://www.alsa-project.org/main/index.php/Asoundrc


