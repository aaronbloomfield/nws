#!/bin/bash

iptables -I FORWARD 1 -p udp -s 192.168.100.2 --dport 53 -j DROP

cd /root/bin && python3 outbound_dns_delay.py &

echo outbound DNS delay enabled
