#Using Processing instead of Pd-extended

In this case, I tried to replace the Pd-extended by the [Processing](https:/processing.org). My attempt was not succesful because of the following reasons:

- CPU usage seems prohibitive. In Kamilla's computer, it can reach around 130% usage in the basic example (only playing the raw video), even if I run the app from outside Processing's IDE. Because of this reason, I didn't even try to stream the video back to youtube;

- Audio does not work out of the box. To make it work with Minim, for example, I'd need to use external libraries such as [JJack](http://jjack.berlios.de/) and [JNAJack](https://github.com/jaudiolibs/). I did not explore this path.

However, if you still want to give it a try, just follow the Pd tutorial, replacing the Pd part by the simple 'webcam.pde' sketch provided in this folder. 

--
[Jeraman](https://jeraman.info), 2016.



