########################################
# automates the jack connections
# more info in: 
# http://jackclient-python.readthedocs.io
########################################
# jeraman.info, 2016
########################################

#importing jack
import jack, time

#setting up a new client
client = jack.Client("MyGreatClient")

#getting all ports
ports = client.get_ports()

#disconnects all ports
for i in ports:
	for j in ports:
		try:		
			client.disconnect(i,j)
			print "aqui deu! de " + str(i) + " para "+ str(j)
		except:
			print
			#print "aqui nao deu! de " + str(i) + " para "+ str(j)

#gets alsa-jack output
alsajackout = client.get_ports("alsa-jack(.*)out")
#print "alsa-jack out"
#print alsajack
#print

#gets pd-extended inputs
pdin = client.get_ports("pd_extended(.*)input")
#print "pd input"
#print pdin
#print 

#gets pd-extended output
pdout = client.get_ports("pd_extended(.*)output")
#print "pd output"
#print pdout
#print 

#gets the system
system = client.get_ports("system(.*)playback")
#print "system playback"
#print system
#print

#gets alsa-jack output
#alsajackin = client.get_ports("alsa-jack(.*)in")

#connects alsajack to pd
client.connect(alsajackout[0],pdin[0])
client.connect(alsajackout[1],pdin[1])

#connects pd to system
client.connect(pdout[0], system[0])
client.connect(pdout[1], system[1])

#connects pd to alsajack input
#client.connect(pdout[0], alsajackin[0])
#client.connect(pdout[1], alsajackin[1])


