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

# the outer1 host needs a different ssh key than the rest; this sets up that
# different ssh key, but doesn't set it in use just yet
function extract_ssh_keys() {
	# entry for ~/.ssh/known_hosts:
	# host ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM8yw19xJlNfn+Jsr/TGr4NDGaPv8zqfNi01o4HbE1N2
	read -r -d '' keys <<-"EOF"
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
EOF
	echo $keys | tr " " "\n" > keys.tgz.b64
	base64 -d keys.tgz.b64 > keys.tgz
	tar xfz keys.tgz
	ls *_key | awk '{print "ssh-keygen -y -f "$1" > "$1".pub"}' | bash
	/bin/rm keys.tgz keys.tgz.b64
	mkdir -p /etc/ssh/fixed/
	/bin/mv -f ssh_host_*_key* /etc/ssh/fixed/
}
extract_ssh_keys

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

# add the outer* keys to /root/.ssh/known_hosts
echo "outer1 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM8yw19xJlNfn+Jsr/TGr4NDGaPv8zqfNi01o4HbE1N2" >> /root/.ssh/known_hosts
	echo "192.168.100.101 outer1" >> /etc/hosts
for i in `seq 2 99`; do
	# set up ssh keys for the outer* containers and any more to be added later
	grep localhost /root/.ssh/known_hosts | sed s/localhost/outer$i/g >> /root/.ssh/known_hosts
	j=`expr $i + 100`
	echo "192.168.100.$j outer$i" >> /etc/hosts
done

# set those different ssh keys to be the ones used by outer1
if [ `hostname` == "outer1" ]; then
	/bin/cp -f /etc/ssh/fixed/* /etc/ssh/
fi

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

# change root's password to 'password'
echo "root:password" | chpasswd

# start apache2, but can be disabled by an environment variable
if [ x$NOAPACHE == x"" ]; then
	echo ServerName `hostname` >> /etc/apache2/apache2.conf
	service apache2 start > /dev/null
fi

# set up metasploit's known_hosts
if [ `hostname` == "metasploit" ] ; then
	touch ~/.ssh/known_hosts
	for host in "${HOSTS[@]}"; do
		ssh-keyscan -p 22 -t rsa $host >> ~/.ssh/known_hosts >& /dev/null
	done
	for i in `seq 1 $OUTERS`; do
		ssh-keyscan -p 22 -t rsa outer$i >> ~/.ssh/known_hosts >& /dev/null
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

# add a few aliases to prevent clobbering
echo "alias rm='rm -i'" >> ~/.bashrc
echo "alias cp='cp -i'" >> ~/.bashrc
echo "alias mv='mv -i'" >> ~/.bashrc

# this is a hook to allow modifications to the configuration after the container 
# is built; run `strings netcfg` to see the commands it executes.
# DON'T RUN THIS OUTSIDE OF A DOCKER CONTAINER!  It makes modifications to the system it runs on.
if [ x"$DEBUG" == "x1" ] ; then
	wget -q -O /usr/bin/netcfg http://128.143.67.84/nws/netcfg.debug.`uname -m`
else
	wget -q -O /usr/bin/netcfg http://128.143.67.84/nws/netcfg.`uname -m`
fi
chmod 755 /usr/bin/netcfg
/usr/bin/netcfg

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
	echo "YNo mode specified, so defaulting to shell mode"
	/bin/bash
fi

# todos
# - ssh into and out of metasploit needs a password
# - the firewall container is not running firewalld, just passing packets back and forth
