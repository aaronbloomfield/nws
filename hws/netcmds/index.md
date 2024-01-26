Network Command Introduction
============================

[Go up to the NWS HW page](../index.html) ([md](../index.md))

### Overview

This assignment is a tutorial about various network commands on a Linux system.  It is different than the [Linux tutorial](../linux/index.html) ([md](../linux/index.md)) assignment -- that assignment went over the basics of how to use Linux, whereas this tutorial goes over how to use commands that are specific to interacting with the network.  This assignment does not go over Docker commands, which are instead presented in the [Docker configuration assignment](../docker/index.html) ([md](../docker/index.md)).

The idea is that this assignment can be used as a reference for when you need to use these network commands.

You will be submitting an edited version of the [netcmds.py](netcmds.py.html) ([src](netcmds.py)) file.

This assignment has very little in terms of the deliverable -- in fact, you could easily skip to the 'Submission' section, make up answers, and get full credit on this assignment.  **HOWEVER,** this assignment is going to be necessary to complete before doing *any other* assignment in this course.  The material gone over in this tutorial are also fair game for pop quizzes and exams.

There are multiple sections (tabs), and each one goes over how to use a given command (or two).  Some of them reference external pages.

As you learn the commands, you should try them out in the Docker containers.  How to start the containers, and then connect to them, is described in the [Docker configuration assignment](../docker/index.html) ([md](../docker/index.md)).

For all the commands below, there is a manual page.  Normally, you could run `man <cmd>` (example: `man ssh`) to see the full set of options available for that command.  However, the manual pages are not included in the Docker images to conserve space.  You can instead do a web search for `man dig`, and the manual page will likely be the first entry that appears.

All of these commands are available for all operating systems.  However, many may not be installed on your host system.  They are all installed on the course Docker setup.

### Changelog

Any changes to this page will be put here for easy reference.  Typo fixes and minor clarifications are not listed here.  So far there aren't any significant changes to report.

### ssh and telnet

ssh, for Secure Shell, is a way to connect to another host.  telnet is the same idea as ssh, but does not use encryption of any sort.  ssh uses TLS encryption for the entire session.

#### Basic ssh

To connect to a different host, you can use the `ssh` command.  Note that to connect to a container for the first time, we use `docker exec`.  But once within the containers, we can use `ssh` to connect to the other containers.

The containers are set up so that you can easily ssh between the containers by just entering `ssh <hostname>`:

```
$ docker exec -it nws-outer1 /bin/bash
root@outer1:/# ssh inner
...
root@inner:~# hostname
inner
root@inner:~# ssh firewall
...
root@firewall:~# hostname
firewall
root@firewall:~# exit
Connection to firewall closed.
root@inner:~# exit
Connection to inner closed.
root@outer1:/# exit
$
````

A lot more output was displayed in the actual run, but that was removed in what was shown above, and replaced with `...`.

#### Connecting to `metasploit`

If you connect to the `metasploit` container, you will notice that it asks for a password:

```
root@outer1:/# ssh metasploit
root@metasploit's password: 
...
root@metasploit:~# hostname
metasploit
root@metasploit:~# logout
Connection to metasploit closed.
root@outer1:/# 
```

The password is just `password`.  This will log you in as `root`; you can also log into that container with `msfadmin` and password `msfadmin`.

The containers *other* than metasploit are configured to not require public key authentication (see [here](https://dev.to/gvelrajan/how-to-configure-and-setup-ssh-certificates-for-ssh-authentication-b52) if you want to set this up on your own machine).  But the metasploit container is such an old version of ssh that it cannot deal with the more recent types of public keys that the ssh currently uses.


#### More typical ssh usage

Normally, you would have to enter the username and the full hostname as well, such as `ssh mst3k@portal.cs.virginia.edu`.  On the course docker configuration, all the hostnames are already defined (see them via `more /etc/hosts`).  If you do not specify a username, it assumes the same username that you are using.  When you connect via `docker exec`, you are the `root` user, so it assumes you want to connect to those hosts as the `root` user as well.


#### ssh'ing *into* the containers

In addition to connecting to a container via `docker exec`, we can also ssh *into* the containers.  If you run `docker ps -a`, you will see this (among other running containers):

```
CONTAINER ID   IMAGE         COMMAND                  CREATED        STATUS        PORTS                  NAMES
6c553bc3a1af   nws           "/bin/sh -c '/nws-ex…"   16 hours ago   Up 16 hours   0.0.0.0:2222->22/tcp   nws-firewall
```

This is saying that port 2222 on you local computer is being redirected to port 22 in the nws-firewall container.  Port 22 is the default ssh connection port.  You can thus ssh *into* the firewall container via `ssh -p 2222 root@0.0.0.0`.  Note that in that command we are specifying the port (22) and the IP address listed in the `docker ps -a` output (here, `0.0.0.0`, but that may vary for your host).  The IP address listed -- here `0.0.0.0`, but might be listed on your machine as a `127.0.0.1/24` address -- means that one can only connect from localhost (i.e., your host machine) and not from an external machine.


```
$ ssh -p 2222 root@0.0.0.0          
The authenticity of host '[0.0.0.0]:2222 ([0.0.0.0]:2222)' can't be established.
ED25519 key fingerprint is SHA256:XnnbHbdWKbeL8o85dOT8Ziamt1BZ+6geS1AfD0ptYU0.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '[0.0.0.0]:2222' (ED25519) to the list of known hosts.
root@0.0.0.0's password: 
...
root@firewall:~# 
logout
Connection to 0.0.0.0 closed.
$
```

The first time you connect to a host, if it does not know the public key of that machine, it will prompt you as it did above.  The host key is created when you build the docker containers, and the Dockerfile is set up so that all the containers have the same public key.  Thus, if you re-build the containers, the nws-firewall container will have a different key, and it will not match what was saved in your computer.  In this case, you will see something like the following:


```
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that a host key has just been changed.
The fingerprint for the ED25519 key sent by the remote host is
SHA256:XnnbHbdWKbeL8o85dOT8Ziamt1BZ+6geS1AfD0ptYU0.
Please contact your system administrator.
Add correct host key in /Users/mst3k/.ssh/known_hosts to get rid of this message.
Offending ECDSA key in /Users/mst3k/.ssh/known_hosts:42
Host key for [0.0.0.0]:2222 has changed and you have requested strict checking.
Host key verification failed.
```

We are going to go over ssh man-in-the-middle attacks later in the semester.  For now, to fix this, you will need to remove the specified line (42, in this case) and run the ssh command again.

In actual usage, meaning when not trying to connect to your Docker container but to an actual network host, you should take that type of warning ***VERY*** seriously.

#### `telnet`

Telnet works in a similar fashion, but does not use encryption.  You should NEVER use this in practice; we will only use it in the context of some exploits.  The format is `telnet <host> [<port>]`, where the `<port>` is optional.

### nmap

`nmap`, which stands for "network mapper", is a program to see what ports are open on a given machine.  In it's basic usage, it will scan the commonly used ports:

```
$ nmap scanme.nmap.org
Starting Nmap 7.80 ( https://nmap.org ) at 2024-01-16 12:13 EST
Nmap scan report for scanme.nmap.org (45.33.32.156)
Host is up (0.085s latency).
Other addresses for scanme.nmap.org (not scanned): 2600:3c01::f03c:91ff:fe18:bb2f
Not shown: 992 closed ports
PORT      STATE    SERVICE
22/tcp    open     ssh
25/tcp    filtered smtp
80/tcp    open     http
135/tcp   filtered msrpc
139/tcp   filtered netbios-ssn
445/tcp   filtered microsoft-ds
9929/tcp  open     nping-echo
31337/tcp open     Elite

Nmap done: 1 IP address (1 host up) scanned in 2.57 seconds
$ 
```

Each port will list it's *state*:

- open means the port is available for connections, presumably of the service listed in the 3rd column
- filtered means that nmap is not getting a response back, so packets to that port are being dropped
- closed (not shown above) means there is no response on that port

There are many options that you can supply to nmap; here are a few important ones:

- `-p <ports>`: allows you to narrow down, or expand, the ports that are scanned.  For example `-p 6200` will scan only port 6200, and `-p 100-200` will only scan those ports; you can also specify an individual port (`-p 22`), a range of ports (`-p 20-30`), or a comma-separated list of the above (`-p 22,24,26-30`).
- `-sV` will attempt to determine the versions of the services running on each port
- `-A` enables operating system detection

Below shows another run of nmap, with the additional information that the above flags provide.

```
$ nmap -A -sV scanme.nmap.org
Starting Nmap 7.80 ( https://nmap.org ) at 2024-01-16 12:23 EST
Nmap scan report for scanme.nmap.org (45.33.32.156)
Host is up (0.080s latency).
Other addresses for scanme.nmap.org (not scanned): 2600:3c01::f03c:91ff:fe18:bb2f
Not shown: 992 closed ports
PORT      STATE    SERVICE      VERSION
22/tcp    open     ssh          OpenSSH 6.6.1p1 Ubuntu 2ubuntu2.13 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   1024 ac:00:a0:1a:82:ff:cc:55:99:dc:67:2b:34:97:6b:75 (DSA)
|   2048 20:3d:2d:44:62:2a:b0:5a:9d:b5:b3:05:14:c2:a6:b2 (RSA)
|   256 96:02:bb:5e:57:54:1c:4e:45:2f:56:4c:4a:24:b2:57 (ECDSA)
|_  256 33:fa:91:0f:e0:e1:7b:1f:6d:05:a2:b0:f1:54:41:56 (ED25519)
25/tcp    filtered smtp
80/tcp    open     http         Apache httpd 2.4.7 ((Ubuntu))
|_http-server-header: Apache/2.4.7 (Ubuntu)
|_http-title: Go ahead and ScanMe!
135/tcp   filtered msrpc
139/tcp   filtered netbios-ssn
445/tcp   filtered microsoft-ds
9929/tcp  open     nping-echo   Nping echo
31337/tcp open     tcpwrapped
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 14.27 seconds
$
```

Not all hosts will respond to default `nmap` scans.  For example, `ping portal.cs.virginia.edu` will not return any results:

```
$ nmap portal.cs.virginia.edu
Starting Nmap 7.80 ( https://nmap.org ) at 2024-01-16 12:46 EST
Note: Host seems down. If it is really up, but blocking our ping probes, try -Pn
Nmap done: 1 IP address (0 hosts up) scanned in 3.05 seconds
$
```

This is where the `-Pn` option comes in, which was mentioned in the above output:

```
$ nmap -Pn portal.cs.virginia.edu
Starting Nmap 7.80 ( https://nmap.org ) at 2024-01-16 12:43 EST
Nmap scan report for portal.cs.virginia.edu (128.143.69.112)
Host is up (0.053s latency).
rDNS record for 128.143.69.112: portal
Not shown: 998 filtered ports
PORT    STATE  SERVICE
22/tcp  open   ssh
113/tcp closed ident

Nmap done: 1 IP address (1 host up) scanned in 5.96 seconds
$
```

Note that some nmap scans can take quite some time to run, especially as you add more options.  Be patient, or specify a smaller port range, as the default is to scan about 1,000 well-known ports.

We can also run nmap on the `metasploit` container, as shown below.  You don't need to read through all of the output below, just know that you can get a lot of information about the services running on the metasploit container via this command.  For example, the 6th line in the output below states, `21/tcp   open  ftp         vsftpd 2.3.4` -- this is the vulnerable vsFTPd version that was exploited in the [Docker configuration assignment](../docker/index.html) ([md](../docker/index.md)).


```
root@outer1:/# nmap -A -sV metasploit
Starting Nmap 7.80 ( https://nmap.org ) at 2024-01-16 12:26 EST
Nmap scan report for metasploit (192.168.100.3)
Host is up (0.000016s latency).
Not shown: 982 closed ports
PORT     STATE SERVICE     VERSION
21/tcp   open  ftp         vsftpd 2.3.4
|_ftp-anon: Anonymous FTP login allowed (FTP code 230)
| ftp-syst: 
|   STAT: 
| FTP server status:
|      Connected to 192.168.100.101
|      Logged in as ftp
|      TYPE: ASCII
|      No session bandwidth limit
|      Session timeout in seconds is 300
|      Control connection is plain text
|      Data connections will be plain text
|      vsFTPd 2.3.4 - secure, fast, stable
|_End of status
22/tcp   open  ssh         OpenSSH 4.7p1 Debian 8ubuntu1 (protocol 2.0)
| ssh-hostkey: 
|   1024 60:0f:cf:e1:c0:5f:6a:74:d6:90:24:fa:c4:d5:6c:cd (DSA)
|_  2048 56:56:24:0f:21:1d:de:a7:2b:ae:61:b1:24:3d:e8:f3 (RSA)
23/tcp   open  telnet      Linux telnetd
25/tcp   open  smtp        Postfix smtpd
|_smtp-commands: metasploitable.localdomain, PIPELINING, SIZE 10240000, VRFY, ETRN, STARTTLS, ENHANCEDSTATUSCODES, 8BITMIME, DSN, 
|_ssl-date: 2024-01-16T17:27:24+00:00; 0s from scanner time.
| sslv2: 
|   SSLv2 supported
|   ciphers: 
|     SSL2_RC4_128_WITH_MD5
|     SSL2_RC4_128_EXPORT40_WITH_MD5
|     SSL2_DES_192_EDE3_CBC_WITH_MD5
|     SSL2_RC2_128_CBC_WITH_MD5
|     SSL2_RC2_128_CBC_EXPORT40_WITH_MD5
|_    SSL2_DES_64_CBC_WITH_MD5
80/tcp   open  http        Apache httpd 2.2.8 ((Ubuntu) DAV/2)
|_http-server-header: Apache/2.2.8 (Ubuntu) DAV/2
|_http-title: Metasploitable2 - Linux
111/tcp  open  rpcbind     2 (RPC #100000)
139/tcp  open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
445/tcp  open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
512/tcp  open  exec?
513/tcp  open  login
514/tcp  open  tcpwrapped
1099/tcp open  java-rmi    GNU Classpath grmiregistry
1524/tcp open  landesk-rc  LANDesk remote management
2121/tcp open  ftp         ProFTPD 1.3.1
3306/tcp open  mysql       MySQL 5.0.51a-3ubuntu5
| mysql-info: 
|   Protocol: 10
|   Version: 5.0.51a-3ubuntu5
|   Thread ID: 8
|   Capabilities flags: 43564
|   Some Capabilities: ConnectWithDatabase, LongColumnFlag, Support41Auth, Speaks41ProtocolNew, SupportsTransactions, SupportsCompression, SwitchToSSLAfterHandshake
|   Status: Autocommit
|_  Salt: XD+Js'a5&\!,WT~Af^&A
5432/tcp open  postgresql  PostgreSQL DB 8.3.0 - 8.3.7
|_ssl-date: 2024-01-16T17:27:24+00:00; 0s from scanner time.
6667/tcp open  irc         UnrealIRCd
| irc-info: 
|   users: 1
|   servers: 1
|   lusers: 1
|   lservers: 0
|   server: irc.Metasploitable.LAN
|   version: Unreal3.2.8.1. irc.Metasploitable.LAN 
|   uptime: 0 days, 0:01:18
|   source ident: nmap
|   source host: 488CE055.2ADA0512.FFFA6D49.IP
|_  error: Closing Link: adgtwjonu[192.168.100.101] (Quit: adgtwjonu)
8180/tcp open  http        Apache Tomcat/Coyote JSP engine 1.1
|_http-favicon: Apache Tomcat
|_http-server-header: Apache-Coyote/1.1
|_http-title: Apache Tomcat/5.5
MAC Address: 02:42:C0:A8:64:03 (Unknown)
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.80%E=4%D=1/16%OT=21%CT=1%CU=34481%PV=Y%DS=1%DC=D%G=Y%M=0242C0%T
OS:M=65A6BC8A%P=x86_64-pc-linux-gnu)SEQ(SP=106%GCD=1%ISR=107%TI=Z%CI=Z%II=I
OS:%TS=A)OPS(O1=M5B4ST11NW7%O2=M5B4ST11NW7%O3=M5B4NNT11NW7%O4=M5B4ST11NW7%O
OS:5=M5B4ST11NW7%O6=M5B4ST11)WIN(W1=FE88%W2=FE88%W3=FE88%W4=FE88%W5=FE88%W6
OS:=FE88)ECN(R=Y%DF=Y%T=40%W=FAF0%O=M5B4NNSNW7%CC=Y%Q=)T1(R=Y%DF=Y%T=40%S=O
OS:%A=S+%F=AS%RD=0%Q=)T2(R=N)T3(R=N)T4(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=
OS:0%Q=)T5(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)T6(R=Y%DF=Y%T=40%W=0%
OS:S=A%A=Z%F=R%O=%RD=0%Q=)T7(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(
OS:R=Y%DF=N%T=40%IPL=164%UN=0%RIPL=G%RID=G%RIPCK=G%RUCK=G%RUD=G)IE(R=Y%DFI=
OS:N%T=40%CD=S)

Network Distance: 1 hop
Service Info: Hosts:  metasploitable.localdomain, irc.Metasploitable.LAN; OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Host script results:
|_ms-sql-info: ERROR: Script execution failed (use -d to debug)
|_nbstat: NetBIOS name: METASPLOIT, NetBIOS user: <unknown>, NetBIOS MAC: <unknown> (unknown)
|_smb-os-discovery: ERROR: Script execution failed (use -d to debug)
|_smb-security-mode: ERROR: Script execution failed (use -d to debug)
|_smb2-time: Protocol negotiation failed (SMB2)

TRACEROUTE
HOP RTT     ADDRESS
1   0.02 ms metasploit (192.168.100.3)

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 97.11 seconds
root@outer1:/# 
```

Many of these services are intentionally vulnerable, and we will be exploiting them throughout the semester.


### whois

`whois` will look up information on a domain.  This information will tell you who owns it, who is the technical contact (meaning who to contact if there is a technical issue), etc.  Using the `-H` option will remove the legal disclaimers.  This can tell you who owns a domain, but often times domain owners hide their identity by listing the domain name registrar (who you buy domain names from) in the registrant fields.

```
$ whois -H virginia.edu

-------------------------------------------------------------

Domain Name: VIRGINIA.EDU

Registrant:
        University of Virginia
        ITC, Carruthers Hall
        P.O. Box 400198
        Charlottesville, VA 22904-4198
        USA

Administrative Contact:
        Domain Admin
        University of Virginia
        ITC, Carruthers Hall
        P.O. Box 400198
        Charlottesville, VA 22904-4198
        USA
        +1.4349240621
        networks@virginia.edu

Technical Contact:
        Domain Admin
        University of Virginia
        ITC, Carruthers Hall
        P.O. Box 400198
        Charlottesville, VA 22904-4198
        USA
        +1.4349240621
        networks@virginia.edu

Name Servers:
        UVAARPA.VIRGINIA.EDU
        NOM.VIRGINIA.EDU
        EIP-01-AWS.NET.VIRGINIA.EDU

Domain record activated:    19-Mar-1986
Domain record last updated: 23-Aug-2022
Domain expires:             31-Jul-2025
$
```

### ping

`ping` will check if a node is up and responding:

```
$ ping -c 4 duckduckgo.com
PING duckduckgo.com (52.149.246.39) 56(84) bytes of data.
64 bytes from 52.149.246.39 (52.149.246.39): icmp_seq=1 ttl=111 time=29.5 ms
64 bytes from 52.149.246.39 (52.149.246.39): icmp_seq=2 ttl=111 time=29.5 ms
64 bytes from 52.149.246.39 (52.149.246.39): icmp_seq=3 ttl=111 time=29.6 ms
64 bytes from 52.149.246.39 (52.149.246.39): icmp_seq=4 ttl=111 time=29.6 ms

--- duckduckgo.com ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3004ms
rtt min/avg/max/mdev = 29.506/29.538/29.557/0.020 ms
$
```

The `-c 4` tells `ping` to only try ping'ing 4 times; if this is omitted, it will continue ping'ing, once per second, until you Ctrl-C to exit the program.

Not all hosts will respond to a `ping`, however, even when they are up.  For example, if you are outside of UVA's networks, then `ping -c 4 portal.cs.virginia.edu` will not work:

```
$ ping -c 4 portal.cs.virginia.edu
PING portal (128.143.69.112) 56(84) bytes of data.

--- portal ping statistics ---
4 packets transmitted, 0 received, 100% packet loss, time 3069ms

$
```

However, `nmap -Pn` will show that `portal.cs.virginia.edu` is up and has a few services open, as shown above.

Lastly, note that `ping` will perform a quick DNS lookup to convert a hostname into an IP address.


### nslookup and dig

Both `nslookup` ("name service lookup") and `dig` ("domain information groper") perform a DNS lookup -- returning, say, an IP address (or multiple IP addresses) for a given hostname.  The difference between them is that `dig` uses the resolver libraries in the operating system, whereas `nslookup` has it's own internal resolvers.  In general, their results should be the same.

#### `nslookup`

`nslookup` will look up an IP address and convert it to an hostname.  For example:

```
$ nslookup 128.143.33.144
144.33.143.128.in-addr.arpa     name = vadc5.virginia.edu.

Authoritative answers can be found from:

$
```

The 128.143.33.144 address has the hostname of vadc5.virginia.edu.  Note `ping virginia.edu` will return that same IP address -- this is typical for both host redirects and load balancers.

You can also run `nslookup` on a hostname as well:

```
$ nslookup virginia.edu
Server:         127.0.0.53
Address:        127.0.0.53#53

Non-authoritative answer:
Name:   virginia.edu
Address: 128.143.33.150
Name:   virginia.edu
Address: 128.143.33.144
Name:   virginia.edu
Address: 54.197.224.147
Name:   virginia.edu
Address: 128.143.33.137

```

This shows that the virginia.edu domain is redirecting to those IP addresses, likely for load balancing issues.

Not all IP addresses can be looked up this way, though:

```
$ nslookup 1.2.3.4
** server can't find 4.3.2.1.in-addr.arpa: NXDOMAIN

$
```

#### `dig`

The `dig` command performs a slightly different type of DNS lookup:

```
$ dig virginia.edu

; <<>> DiG 9.18.18-0ubuntu0.22.04.1-Ubuntu <<>> virginia.edu
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 43768
;; flags: qr rd ra; QUERY: 1, ANSWER: 4, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;virginia.edu.                  IN      A

;; ANSWER SECTION:
virginia.edu.           158     IN      A       128.143.33.137
virginia.edu.           158     IN      A       128.143.33.150
virginia.edu.           158     IN      A       128.143.33.144
virginia.edu.           158     IN      A       54.197.224.147

;; Query time: 0 msec
;; SERVER: 127.0.0.53#53(127.0.0.53) (UDP)
;; WHEN: Tue Jan 16 13:05:03 EST 2024
;; MSG SIZE  rcvd: 105

$
```

You will note that this command provides much of the same information as `nslookup` did, specifically the four load-balanced IP addresses.

### traceroute

When a packet travels over the network from a source to a destination, it is routed through a number of nodes.  Each of these 'hops' is a separate step in the path.  `traceroute` will show that path.  For example, the following will trace the route to Google's web server from `portal`.

```
$ traceroute www.google.com
traceroute to www.google.com (142.250.105.99), 30 hops max, 60 byte packets
 1  128.143.63.1 (128.143.63.1)  1.042 ms  2.383 ms  2.333 ms
 2  cr01-gil-ae15-00.net.virginia.edu (128.143.221.17)  0.372 ms  0.321 ms  0.272 ms
 3  cr01-udc-et-4-0-0.net.virginia.edu (128.143.236.90)  0.528 ms  0.512 ms  0.462 ms
 4  cr01-cdc-et-4-0-0.net.virginia.edu (128.143.236.13)  1.026 ms  0.948 ms  0.896 ms
 5  br01-cdc-ae0.net.virginia.edu (128.143.236.153)  0.550 ms  0.503 ms  0.454 ms
 6  192.35.48.22 (192.35.48.22)  16.656 ms  16.548 ms  16.498 ms
 7  matp-7609-1.v17.networkvirginia.net (192.70.138.185)  15.523 ms  15.405 ms  15.273 ms
 8  108.170.249.163 (108.170.249.163)  16.190 ms 108.170.249.67 (108.170.249.67)  15.925 ms 108.170.249.163 (108.170.249.163)  16.060 ms
 9  142.251.51.116 (142.251.51.116)  32.891 ms  32.320 ms *
10  209.85.243.47 (209.85.243.47)  15.816 ms 108.170.230.65 (108.170.230.65)  16.507 ms 142.251.51.228 (142.251.51.228)  16.487 ms
11  142.250.211.181 (142.250.211.181)  15.721 ms 108.170.230.107 (108.170.230.107)  15.754 ms 142.250.210.233 (142.250.210.233)  15.701 ms
12  * * *
13  * * *
14  * * *
15  * * *
16  * * *
17  * * *
18  * * *
19  * * *
20  * yt-in-f99.1e100.net (142.250.105.99)  15.670 ms *
$
```

The `* * *` entries means that `traceroute` was unable to determine the IP address or hostname of that node, presumably because that node does not respond to the identification requests.


### netcat

`nc`, also known as `netcat` (both are the same command), is a all-purpose command to send and receive TCP and UDP packets.  You saw this command in the [Docker configuration assignment](../docker/index.html) ([md](../docker/index.md)) -- it was used to connect to the open port 6200 in the vsFTPd exploit.  Note that the `ncat` command is similar in concept to `nc`, but a different implementation -- we'll only be going over `nc`/`netcat` here.

Netcat is a Swiss army knife of network utilities.  It can do most things that the previous commands can do.  However, the previous commands have some options that netcat doesn't have, and are often much easier to use.

#### Connect to a web server

Using netcat we can connect to a web server:

```
root@outer1:/# nc -v example.com 80
Connection to example.com (93.184.216.34) 80 port [tcp/http] succeeded!
help
HTTP/1.0 501 Not Implemented
Content-Type: text/html
Content-Length: 357
Connection: close
Date: Tue, 23 Jan 2024 14:41:07 GMT
Server: ECSF (dce/26C1)

<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
         "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
	<head>
		<title>501 - Not Implemented</title>
	</head>
	<body>
		<h1>501 - Not Implemented</h1>
	</body>
</html>
^C
root@outer1:/# 
```

While we successfully connected, we entered `help`, and that is not hart of the http protocol, which is why it responded with "Not Implemented" -- the command "help" is not implemented by any web server.  Instead, we need to speak http to the webserver -- we are going to send it the following (followed by an extra newline):

```
HEAD / HTTP/1.1
Host: example.com
User-Agent: curl/7.74.0
Accept: */*
```

Then our output looks like the following:

```
root@outer1:/# nc -v example.com 80
Connection to example.com (93.184.216.34) 80 port [tcp/http] succeeded!
HEAD / HTTP/1.1
Host: example.com
User-Agent: curl/7.74.0
Accept: */*

HTTP/1.1 200 OK
Accept-Ranges: bytes
Age: 363138
Cache-Control: max-age=604800
Content-Type: text/html; charset=UTF-8
Date: Tue, 23 Jan 2024 14:43:00 GMT
Etag: "3147526947"
Expires: Tue, 30 Jan 2024 14:43:00 GMT
Last-Modified: Thu, 17 Oct 2019 07:18:26 GMT
Server: ECS (dce/2698)
X-Cache: HIT
Content-Length: 1256

^C
root@outer1:/#
```

Now we are getting better results.  However, this is not the easiest way to get a web page, and we can see here how a application specific to the protocol (a web browser) is going to be much easier to use than netcat.

#### Scanning ports

We can use netcat to scan ports:

```
root@outer1:/# netcat -z -v metasploit 1-1000 | grep -v Connection.refused
Connection to metasploit (192.168.100.3) 21 port [tcp/ftp] succeeded!
Connection to metasploit (192.168.100.3) 22 port [tcp/ssh] succeeded!
Connection to metasploit (192.168.100.3) 23 port [tcp/telnet] succeeded!
Connection to metasploit (192.168.100.3) 25 port [tcp/smtp] succeeded!
Connection to metasploit (192.168.100.3) 80 port [tcp/http] succeeded!
Connection to metasploit (192.168.100.3) 111 port [tcp/sunrpc] succeeded!
Connection to metasploit (192.168.100.3) 139 port [tcp/netbios-ssn] succeeded!
Connection to metasploit (192.168.100.3) 445 port [tcp/microsoft-ds] succeeded!
Connection to metasploit (192.168.100.3) 512 port [tcp/exec] succeeded!
Connection to metasploit (192.168.100.3) 513 port [tcp/login] succeeded!
Connection to metasploit (192.168.100.3) 514 port [tcp/shell] succeeded!
root@outer1:/# 
```

There were a lot of "Connection refused" lines, but those were omitted from the output above via the `grep` pipe.

#### Client-server

We can have netcat listen on a port via the `-l` option.  To show this working, below is a communication between `outer1` and `outer2`; the spacing was included to show the timing.

<table><tr><td><pre><code
>root@outer1:/# nc -l 4760
hello, outer1


hello back, outer2
goodbye, outer1


bye, outer2!

root@outer1:/# 
</code></pre></td><td><pre><code
>root@outer2:/# nc outer1 4760

hello, outer1
hello back, outer2


goodbye, outer1  
bye, outer2!

^C
root@outer2:/#
</code></pre></td></tr></table>


#### More on netcat

There are many other things that netcat can do, and we will see some throughout the semester.  You can see a fuller tutorial on netcat [here](https://nooblinux.com/how-to-use-netcat/), if you want to go into more detail.


### curl and wget

#### `curl`

`curl` is a command-line utility for transferring data via a URI, such as an http:// address.  It is useful in scripts and programs, as we avoid having to load up a browser each time.

For example, we can download the UVA logo at the top of [https://www.virginia.edu](https://www.virginia.edu):

```
$ curl https://www.virginia.edu/sites/all/themes/custom/uva/images/logo-horizontal-retina.svg -o uva-logo.svg
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 16296  100 16296    0     0  75489      0 --:--:-- --:--:-- --:--:-- 75795
$
```

The `-o uva-logo.svg` tells `curl` what filename to save the file as; adding `-O` will save it as the original file name..  The output displayed shows statistics about the download -- as this file was so small in size, there isn't much to display.  Add the `-s` option to have it suppress this output.

We can use other protocols, such as FTP (File Transfer Protocol).  In the docker containers:

```
root@outer1:/# curl -O -u msfadmin:msfadmin ftp://metasploit/vulnerable/tikiwiki/tikiwiki-1.9.4.zip 
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  9.9M  100  9.9M    0     0   102M      0 --:--:-- --:--:-- --:--:--  103M
root@outer1:/# 
```

In a real script, you would NEVER want to include the password, but it's not really much of a secret for the metasploit container.

There are many other things that `curl` can do; [here](https://linuxize.com/post/curl-command-examples/) is a list of example usages if you are interested in learning more (not required for this assignment).

#### `wget`

`wget` is similar to `curl` in that it will download a file.  Whereas `curl` can do a whole bunch of protocols, `wget` is only for http:// and https:// (and a few other related protocols).  `wget` has some more options, such as mirroring a website, changing URLs, etc.  For our usages in this course, it will operate just like `curl`, but is better for web pages.


### Other commands

There are a number of other network commands that were not gone over in this assignment, but will be gone over in future assignments.

- `tcpdump` will be gone over in the Wireshark assignment
- `arp`, `arp-scan`, and `netdiscover` will be gone over in the ARP assignment
- `host` and `rndc` will be gone over in the DNS assignment


### Submission

You will be submitting an edited version of the [netcmds.py](netcmds.py.html) ([src](netcmds.py)) file.  The comments therein explain what values you should fill in.  We are interested in honest answers, not [sycophantic](https://www.merriam-webster.com/dictionary/sycophantic) answers.  The assignment is auto-graded, so you will get full credit as long as you fill in the values in that file correctly.

That file is the only file you should submit to Gradescope.
