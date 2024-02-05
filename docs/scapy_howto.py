#!/usr/bin/python3

# These are examples of how to perform various functions in scapy.  The parts
# below that require parameters are in functions; the ones that do not
# require parameters are included in the print statements in `main()`

from scapy.all import *

# This will return all the IP addresses of localhost on all the network
# interfaces.
def get_ip_list_of_localhost():
	return set([ x[4] for x in read_routes() ])

# given a hostname, local or otherwise, it will resolve it to an IP address.
# If there are many IP addresses, this will return only one of them.
def resolve_hostname_to_ip(name):
	return socket.gethostbyname(name)

# scapy sniff() filter howto at https://biot.com/capstats/bpf.html

# to send without output, but `verbose=False` as a parameter to send() or sr1()

def main():
	print("localhost's IP list:",get_ip_list_of_localhost())
	print("duckduckgo.com's IP:",resolve_hostname_to_ip("duckduckgo.com"))
	print("localhost hostname :",socket.gethostname())


if __name__ == "__main__":
	main()
