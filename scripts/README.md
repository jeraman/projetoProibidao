#Step-by-step tutorial

1. Run the 'from_youtube_to_pd.sh' script, passing the url of the targeted live youtube video as parameter;

2. Modify the Jack patch, so that there are only two connections: a) pd-extended->system; and b) ffmpeg-ouput->pd-extended.

3. Run the 'from_pd_to_youtube.sh' script, passing your live youtube video ID as parameter;

4. Modify the Jack patch, so that you add the pd-extended->ffmpeg-input to the connections.

The resulting Jack patch should look like this:
![Jack] (jack-connections.png)

