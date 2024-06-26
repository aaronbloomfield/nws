FROM ubuntu:22.04
LABEL maintainer="Aaron Bloomfield aaron@virginia.edu"
ENV DEBIAN_FRONTEND noninteractive

ARG APT_PROXY=0.0.0.0
RUN echo $APT_PROXY | grep -v 0.0.0.0 | awk '{print "Acquire::http::Proxy \"http://" $1 ":3142\";"}' > /etc/apt/apt.conf.d/02proxy

#CMD ["/usr/bin/xclock"]

RUN apt update -y -q -q && \
	apt dist-upgrade -y -q -q && \
	apt install -y -q -q apt-utils locales tzdata && \
	locale-gen en_US.UTF-8 && \
	ln -fs /usr/share/zoneinfo/US/Eastern /etc/localtime && \
	dpkg-reconfigure -f noninteractive tzdata

RUN apt install -y -q \
		curl gnupg wireshark firewalld  nmap iputils-ping traceroute net-tools \
		x11-apps openssh-server g++ gdb less emacs emacs-nox nano vim netdiscover \
		dsniff git lynx apache2 libapache2-mod-php software-properties-common \
		netcat ncat apt-transport-https libpci-dev python3-pip arp-scan lsof \
		libssl-dev snort tor kmod astyle source-highlight zip unzip sharutils sudo \
		telnet ftp bind9-utils bind9-host bind9-dnsutils whois tcpdump fcrackzip \
		tshark libpcap0.8-dev libboost-all-dev conntrack konwert tofrodos arping bind9 bind9utils wamerican tcpreplay

RUN systemctl disable named && \
	curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > /tmp/msfinstall && \
	chmod 755 /tmp/msfinstall && \
	/tmp/msfinstall && \
	apt clean -y && \
	echo "#include <unistd.h>" > /sleep.c && \
	echo "int main() { while (1) sleep(10); return 0; }" >> /sleep.c && \
	gcc -o /sleep /sleep.c && \
	ssh-keygen -f /root/.ssh/id_rsa -N "" && \
	cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys && \
	sed -i s/"#PermitRootLogin"/PermitRootLogin/g /etc/ssh/sshd_config && \
	awk '{print "localhost " $1 " " $2}' /etc/ssh/ssh_host_ed25519_key.pub > ~/.ssh/known_hosts && \
	echo 'alias ssh="ssh -oHostKeyAlgorithms=+ssh-dss"' >> ~/.bashrc && \
	rm -f /etc/apt/apt.conf.d/02proxy && \
	add-apt-repository -y ppa:mozillateam/ppa && \
	apt update -y && \
	apt install -y -q -q firefox-esr && \
	echo "alias firefox=firefox-esr" >> ~root/.bashrc && \
	pip install --pre scapy[basic] requests rsa ecdsa && \
	mkdir -p /mnt && \
	git clone https://gitlab.com/exploit-database/exploitdb /usr/local/exploitdb && \
	ln -s /usr/local/exploitdb/searchsploit /usr/local/bin/searchsploit && \
	cp /usr/local/exploitdb/.searchsploit_rc /root/

EXPOSE 22
COPY nws-exec.sh /nws-exec.sh
RUN chmod 755 /nws-exec.sh
CMD '/nws-exec.sh'

# Installation notes:
#
# the git clone of the exploitdb database was to install searchsploit, adapted from 
# https://4siteadvantage.com/linux/how-to-install-exploit-db-searchsploit-on-ubuntu-19/
#
# Packages:
# apt-utils: allows the package installations to work better
# locales tzdata: timezone packages
# curl: needed for some of the installs herein
# gnupg: PGP (i.e., RSA) encryption for email
# wireshark: network packet analyzer
# firewalld: one of multiple firewall programs that can be used
# nmap iputils-ping traceroute net-tools: various basic network utilities
# x11-apps: to test running a GUI from a docker container
# openssh-server: so we can ssh back and forth between the containers
# g++ gdb: C/C++ compiler and debugger
# less: a replacement for more
# emacs emacs-nox nano vim: editors
# netdiscover dsniff: needed for ARP spoofing
# git: beccause git
# lynx: a text-based web browser
# apache2 libapache2-mod-php: the apache2 web server
# software-properties-common: necessary for the installation of other packages
# netcat ncat: for the 'nc' and `ncat` commands
# apt-transport-https: allows HTTPS tunnels
# libpci-dev: so firefox doesn't complain
# python3-pip: because duh
# arp-scan: for the ARP homework
# lsof: check what has open files and ports
# libssl-dev: the SSL libraries
# snort: network monitoring software
# tor: anonymous web browser
# kmod: to manage linux kernel modules
# astyle source-highlight: for making program code look pretty
# zip unzip sharutils: for archive files
# telnet ftp: basic network utilities
# bind9 bind9utils bind9-utils bind9-host bind9-dnsutils: DNS & utilities
# whois: whois directory service
# tcpdump: tcpdump
# fcrackzip: to crack passwords
# sudo: some installation scripts (msfinstall) need this

