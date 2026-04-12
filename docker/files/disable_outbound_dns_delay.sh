#!/bin/bash

iptables -D FORWARD -p udp -s 192.168.100.2 --dport 53 -j DROP

ps aux | grep outbound_dns_delay.py | grep -v grep | awk '{print "kill -9 "$2}' | bash

echo outbound DNS delay disabled
