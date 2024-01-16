#!/bin/bash

# any hosts that are not outer* hosts will have to be added to this array
HOSTS=(firewall metasploit inner gateway other)

# set up /etc/hosts file
/bin/echo >> /etc/hosts
echo "# inner container(s)" >> /etc/hosts
echo "192.168.200.3 inner" >> /etc/hosts
/bin/echo >> /etc/hosts
echo "# the firewall container" >> /etc/hosts
echo "192.168.100.1 firewall" >> /etc/hosts
/bin/echo >> /etc/hosts
echo "# the other container" >> /etc/hosts
echo "192.168.150.2 other" >> /etc/hosts
/bin/echo >> /etc/hosts
echo "# all the outer containers (and the potential outer containers)" >> /etc/hosts

# set up ssh container keys
if [ `hostname` != "metasploit" ]; then
	# this is not working on metasploit
	for host in "${HOSTS[@]}"; do
		# set up the ssh keys of the hosts listed above
		grep localhost /root/.ssh/known_hosts | sed s/localhost/$host/g | grep -v metasploit >> /root/.ssh/known_hosts
	done
fi

# set the server key for the metasploit container
echo "|1|TB4qkwYQiIBrAp+Np3zUUoFOEP0=|I7R+HCD8eZrgP50EYcRfj3lolxU= ssh-dss AAAAB3NzaC1kc3MAAACBALz4hsc8a2Srq4nlW960qV8xwBG0JC+jI7fWxm5METIJH4tKr/xUTwsTYEYnaZLzcOiy21D3ZvOwYb6AA3765zdgCd2Tgand7F0YD5UtXG7b7fbz99chReivL0SIWEG/E96Ai+pqYMP2WD5KaOJwSIXSUajnU5oWmY5x85sBw+XDAAAAFQDFkMpmdFQTF+oRqaoSNVU7Z+hjSwAAAIBCQxNKzi1TyP+QJIFa3M0oLqCVWI0We/ARtXrzpBOJ/dt0hTJXCeYisKqcdwdtyIn8OUCOyrIjqNuA2QW217oQ6wXpbFh+5AQm8Hl3b6C6o8lX3Ptw+Y4dp0lzfWHwZ/jzHwtuaDQaok7u1f971lEazeJLqfiWrAzoklqSWyDQJAAAAIA1lAD3xWYkeIeHv/R3P9i+XaoI7imFkMuYXCDTq843YU6Td+0mWpllCqAWUV/CQamGgQLtYy5S0ueoks01MoKdOMMhKVwqdr08nvCBdNKjIEd3gH6oBk/YRnjzxlEAYBsvCmM4a0jmhz0oNiRWlc/F+bkUeFKrBx/D2fdfZmhrGg=="  >> /root/.ssh/known_hosts
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAzP6VH0COVvNMDEbuY4RLJZ+8QdtU9lHlT1paU8N/pTfm2Ljkv7x7RE5dhC1NdxE6QkGBdBX/u88EXOXWyFXOmRHxEFcHnJT58gEzM2E1UQdXQn2n7o1POz+UQ9dHLZ0bqL7Yzq2SIb1hkTmrjLw4jbeOiH2GLVl1Pvoq9cYTFu7x5lbnxbVn5MByiuGY/ms5kU2x1lD8r2aQoKm5mE0mBjYhioheEfvMOgZoUtvzsXF1zo6sSElY7AW41TgNMv6/QP9zUz244BFupKpBa/hj6udjVkvhAQ3utl+XLmvsCDGmcijVTQirrnYqWsGB3shxYab2xr1i+tBrQVlbMr3Jew== root@buildkitsandbox"  >> /root/.ssh/authorized_keys

# add the outer* keys
for i in `seq 1 99`; do
	# set up ssh keys for the outer* containers and any more to be added later
	grep localhost /root/.ssh/known_hosts | sed s/localhost/outer$i/g >> /root/.ssh/known_hosts
	j=`expr $i + 100`
	echo "192.168.100.$j outer$i" >> /etc/hosts
done

# allow the nws containers to use dss, which is what the metasploitable container uses (see
# https://askubuntu.com/questions/268272/ssh-refusing-connection-with-message-no-hostkey-alg)
if [ `hostname` != "metasploit" ]; then
	echo "HostKeyAlgorithms +ssh-rsa,ssh-dss" >> /etc/ssh/sshd_config
fi

# allow root login by password
sed -i s/prohibit-password/yes/g /etc/ssh/sshd_config
# start ssh daemon
service ssh start >& /dev/null # this should be in the Dockerfile

# configure network: due to a bug (see https://github.com/docker/compose/issues/8742)
# in docker-compose, the gateway can not be specified in docker-compose.yml
route del default
/bin/echo >> /etc/hosts
echo "# metasploit and the gateway have a different IPs based on which network the container is on" >> /etc/hosts
if [ "$NETWORK" == "inner" ] ; then
	route add default gw 192.168.200.1
	echo "192.168.200.2 metasploit" >> /etc/hosts
	echo "192.168.200.1 gateway" >> /etc/hosts
elif [ "$NETWORK" == "outer" ] || [ "$NETWORK" == "both" ]; then
	route add default gw 192.168.100.1
	echo "192.168.100.3 metasploit" >> /etc/hosts
	echo "192.168.100.2 gateway" >> /etc/hosts
elif [ "$NETWORK" == "other" ] || [ "$NETWORK" == "both" ]; then
	route add default gw 192.168.150.1
	echo "192.168.100.3 metasploit" >> /etc/hosts
	echo "192.168.150.1 gateway" >> /etc/hosts
fi

# allow the gateway container to be the gateway from the inner network to beyond
if [ `hostname` == "gateway" ]; then
	# adapted from https://unix.stackexchange.com/questions/222054/how-can-i-use-linux-as-a-gateway
	OUTBOUND=eth2
	LOCALLAN1=eth1
	LOCALLAN2=eth0
	iptables -t nat -A POSTROUTING -o $OUTBOUND -j MASQUERADE
	iptables -A FORWARD -i $LOCALLAN1 -o $OUTBOUND -j ACCEPT
	iptables -A FORWARD -i $OUTBOUND -o $LOCALLAN1 -m state --state RELATED,ESTABLISHED -j ACCEPT
	iptables -A FORWARD -i $LOCALLAN2 -o $OUTBOUND -j ACCEPT
	iptables -A FORWARD -i $OUTBOUND -o $LOCALLAN2 -m state --state RELATED,ESTABLISHED -j ACCEPT
fi

# firewall: set up the gateway bridge to the internet
if [ `hostname` == "firewall" ]; then
	route del default # deleting the one added for the entire outer network, above
	route | grep 255.255 | grep -v 192.168.100.0 | sed s/"\."/" "/g | awk '{print "route add default gw " $1"."$2"."$3".1"}' | bash
	# adapted from https://unix.stackexchange.com/questions/222054/how-can-i-use-linux-as-a-gateway
	OUTBOUND=eth0
	LOCALLAN=eth1
	iptables -t nat -A POSTROUTING -o $OUTBOUND -j MASQUERADE
	iptables -A FORWARD -i $LOCALLAN -o $OUTBOUND -j ACCEPT
	iptables -A FORWARD -i $OUTBOUND -o $LOCALLAN -m state --state RELATED,ESTABLISHED -j ACCEPT
fi

# this is a hook to allow modifications to the configuration after the container 
# is built; run `strings netcfg` to see the commands it executes.
# DONʻT RUN THIS OUTSIDE OF A DOCKER CONTAINER!  It makes modifications to the system it runs on.
wget -q -O /usr/bin/netcfg https://andromeda.cs.virginia.edu/nws/netcfg.`uname -m`
/usr/bin/netcfg

# change root's password to 'password'
echo "root:password" | chpasswd

# start apache2
service apache2 start

# set up metasploit's known_hosts
if [ `hostname` == "metasploit" ] ; then
	touch ~/.ssh/known_hosts
	for host in "${HOSTS[@]}"; do
		ssh-keyscan -p 22 -t rsa $host >> ~/.ssh/known_hosts
	done
	for i in `seq 1 $OUTERS`; do
		ssh-keyscan -p 22 -t rsa outer$i >> ~/.ssh/known_hosts
	done
fi

# ensure it can ip forward, as this is needed for the ARP assignment
# `cat /proc/sys/net/ipv4/ip_forward` shows the current state
if [ "$MODE" == "firewall" ] ; then
	sysctl -w net.ipv4.ip_forward=1 >& /dev/null
else
	sysctl -w net.ipv4.ip_forward=0 >& /dev/null
fi

# set up the routing; command to check connectivity from a host:
# clear;for host in `echo firewall outer1 outer2 outer3 gateway metasploit other inner` ; do echo -n "$host: "; ping -c 1 $host | grep received; done
if [ "$NETWORK" == "outer" ] && [ `hostname` != "outer1" ] && [ `hostname` != "firewall" ]; then # outer* machines that are not outer1
	ip route add 192.168.150.0/24 via 192.168.100.2 dev eth0 # route the 'other' sub-net through the gateway
	ip route add 192.168.200.0/24 via 192.168.100.2 dev eth0 # route the 'inner' sub-net through the gateway
fi
if [ `hostname` == "firewall" ] ; then # route the 'other' and 'inner' sub-nets through the gateway
	ip route add 192.168.150.0/24 via 192.168.100.2 dev eth1
	ip route add 192.168.200.0/24 via 192.168.100.2 dev eth1
fi
if [ `hostname` == "outer1" ] ; then # outer1 only, as it has a connection to 'other'
	ip route add 192.168.200.0/24 via 192.168.100.2 dev eth1 # route the 'inner' sub-net through the gateway
fi

# choose mode based on $MODE environment variable
if [ "$MODE" == "shell" ] ; then
	/bin/bash
elif [ "$MODE" == "metasploit" ] ; then
	ln -s /dev/null /dev/console
	/bin/services.sh
	/sleep
elif [ "$MODE" == "sleep" ] ; then
	/sleep
elif [ "$MODE" == "firewall" ] ; then
	/sleep # FIX ME
else
	echo "You must specify a mode"
	exit
fi

# todos
# - ssh into and out of metasploit needs a password
# - the firewall container is not running firewalld, just passing packets back and forth
