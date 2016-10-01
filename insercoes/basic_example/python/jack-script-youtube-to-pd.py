########################################
# automates the jack connections
# more info in: 
# http://jackclient-python.readthedocs.io
########################################
# jeraman.info, 2016
########################################

#importing jack
import jack, time, sys

#setting up a new client
client = jack.Client("MyGreatClient")

#wait a little bit
time.sleep(2)

#getting all ports
ports = client.get_ports()

#printing them
print "ports are:"
print ports
print 

#disconnects all ports
for i in ports:
	for j in ports:
		try:		
			client.disconnect(i,j)
			print "aqui deu! de " + str(i) + " para "+ str(j)
		except:
			"nada"

#gets alsa-jack output
alsajackout = client.get_ports("alsa-jack(.*)out")

#print "alsa-jack out"
if alsajackout.__len__()==0:
	print "[ERROR!]  No alsa jack output found in Jack. Please, try again. "
	sys.exit(1)

#gets pd-extended inputs
pdin = client.get_ports("pd_extended(.*)input")

#gets pd-extended output
pdout = client.get_ports("pd_extended(.*)output")

#gets the system
system = client.get_ports("system(.*)playback")

#connects alsajack to pd
client.connect(alsajackout[0],pdin[0])
client.connect(alsajackout[1],pdin[1])

#connects pd to system
client.connect(pdout[0], system[0])
client.connect(pdout[1], system[1])

#connects pd to alsajack input
#client.connect(pdout[0], alsajackin[0])
#client.connect(pdout[1], alsajackin[1])


