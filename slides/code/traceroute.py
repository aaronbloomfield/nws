#!/usr/bin/python3

# traceroute program using scapy

import sys
from scapy.all import *

dest ='142.250.80.100' # google.com
dest = '128.143.67.11' # www.cs.virginia.edu

for TTL in range(1,40):
	response = sr1(IP(dst=dest,ttl=TTL)/ICMP(), timeout=2, verbose=0)
	if response is None:
		print("%2d * * *" % TTL)
	else:
		print("%2d %s" % (TTL,response.src))
	if ( response is not None and response.src == dest ):
		break;