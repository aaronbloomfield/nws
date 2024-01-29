#!/usr/bin/python
from scapy.all import *
ip = "128.143.67.11" # www.cs.virginia.edu
pkt = IP(dst=ip) / ICMP(type=8)
reply = sr1(pkt)
print ("Reply from", reply[IP].src, "with destination", 
	   reply[IP].dst)
