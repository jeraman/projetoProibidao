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

#gets alsa-jack input
alsajackin = client.get_ports("alsa-jack(.*)in")

#print "alsa-jack out"
if alsajackin.__len__()==0:
	print "[ERROR!]  No alsa jack output found in Jack. Please, try again. "
	sys.exit(1)

#gets pd-extended output
pdout = client.get_ports("pd_extended(.*)output")

#gets the system
system = client.get_ports("system(.*)capture")

#disconnects system from alsa
client.disconnect(system[0], alsajackin[0])
client.disconnect(system[1], alsajackin[1])

#connects pd to alsajackin
client.connect(pdout[0], alsajackin[0])
client.connect(pdout[1], alsajackin[1])

#connects pd to alsajack input
#client.connect(pdout[0], alsajackin[0])
#client.connect(pdout[1], alsajackin[1])


