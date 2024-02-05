#!/usr/bin/python3

import socket, sys
mode = sys.argv[1]
remotehost = sys.argv[2]
PORT = 5678
other_ip = socket.gethostbyname(remotehost)

if mode == "server":
	sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
	sock.bind(("0.0.0.0", PORT))
elif mode == "client":
	sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

if mode == "client":
	sock.sendto(b"hello, world", (other_ip, PORT))
	print(mode,"sent 'hello, world' to server at",other_ip)

if mode == "server":
	data, (ip, port) = sock.recvfrom(2**16)
	print(mode,"received",data,"from",ip,port)
	sock.sendto(b"goodbye!", (other_ip, port))
	print(mode,"sent 'goodbye!' to client at",other_ip,port)
	
if mode == "client":
	data, (ip, port) = sock.recvfrom(2**16)
	print(mode,"received",data,"from server at",ip,port)
