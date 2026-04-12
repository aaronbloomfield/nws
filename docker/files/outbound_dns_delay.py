#!/usr/bin/python3

from scapy.all import *
import time, threading

"""
This program will monitor all connections across *firewall*(192.168.100.1) for
DNS queries and responses.  All queries are delayed (outbound) by the amount
in `delay_sec`.  All responses are forwarded to gateway, but the iptables
command, below, only intercepts those packets.  This does not affect the DNS
server on outer3.

The following iptables command must be run to drop the outbound packets:

iptables -I FORWARD 1 -p udp -s 192.168.100.2 --dport 53 -j DROP
"""

delay_sec = 0.5
verbose = False

portmap = {}

eth0_ip = get_if_addr('eth0')
eth1_ip = get_if_addr('eth1')

def send_dns_reply_to_gateway(packet):
	pkt = packet[IP]
	#print(portmap)
	dport = portmap[pkt[DNS].id]
	del portmap[pkt[DNS].id]
	if verbose:
		print("inbound received:",pkt.summary(),"from",pkt[IP].src,"->",pkt[IP].dst,"s/dport",pkt[UDP].sport,pkt[UDP].dport,"id/sport",pkt[DNS].id,dport)
	newpkt = IP(dst="192.168.100.2",src="8.8.8.8") / UDP(sport=53,dport=dport) / pkt[DNS]
	if verbose:
		print("inbound forward:",newpkt.summary(),"from",newpkt[IP].src,"->",newpkt[IP].dst,"dport",newpkt[UDP].dport)
	send(newpkt,iface='eth1',verbose=0)
	#exit()

def delay_outbound_dns(packet):
	time.sleep(delay_sec)
	pkt = packet[IP]
	if verbose:
		print()
		print("outbound received:",pkt.summary(),"from",pkt[IP].src,"->",pkt[IP].dst,"id/sport:",pkt[DNS].id,pkt[UDP].sport)
	portmap[pkt[DNS].id] = pkt[UDP].sport
	del pkt[IP].chksum
	Qdsec    = DNSQR(qname='www.virginia.edu') 
	DNSpkt   = DNS(id=100, qr=0, qdcount=1, qd=Qdsec)
	newpkt = IP(dst="8.8.8.8") / UDP(dport=53) / pkt[DNS]
	#newpkt[DNS].id = 1234
	if verbose:
		print("outbound sent:",newpkt.summary(),"from",newpkt[IP].src,"->",newpkt[IP].dst)
	#ls(newpkt)
	reply = sr1(newpkt,iface='eth0',verbose=0)
	if verbose:
		print("outbound reply:",reply.summary(),"from",reply[IP].src,"->",reply[IP].dst)
	#exit()

def run_send_dns_reply_to_gateway():
	if verbose:
		print("sniffing inbound")
	sniff(iface='eth0',filter="udp and dst port 53 and ip dst host " + eth0_ip, prn=send_dns_reply_to_gateway)

def run_delay_outbound_dns():
	if verbose:
		print("sniffing outbound")
	sniff(iface='eth1',filter="udp and dst port 53 and ip src net 192.168.0.0/16", prn=delay_outbound_dns)

threading.Thread(target=run_send_dns_reply_to_gateway, args=(), daemon=True).start()
run_delay_outbound_dns()
