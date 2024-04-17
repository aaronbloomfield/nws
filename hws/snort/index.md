Snort Assignment
=================

[Go up to the NWS HW page](../index.html) ([md](../index.md)).


### Overview

In this assignment you will be investigating [Snort](https://www.snort.org/), which is a tool to help monitor networks.  For an introduction to Snort, read the [very short Wikipedia article on Snort](https://en.wikipedia.org/wiki/Snort_(software)).

Snort is already installed on the docker containers.  We will be running Snort on *gateway*, and our network connections will be running from *inner*.

You will be submitting an edited version of [snort.py](snort.py.html) ([src](snort.py)).

Note: this assignment is for Snort 2.9.15.1, which is the version installed via `apt` on Ubuntu 22.04.  While Snort 3.x is out, it is not as easily installed, and thus we will not be looking at Snort 3.  Some of the tutorial aspects in this assignment were taken from the [Rapid7: How to Install Snort NIDS on Ubuntu Linux](https://www.rapid7.com/blog/post/2017/01/11/how-to-install-snort-nids-on-ubuntu-linux/) webpage.

If you are looking for the Snort documentation, make sure to use the 2.9 documentation, which can be found online in [HTML](https://www.snort.org/documents/snort-users-manual-2-9-16-html) and [PDF](https://www.snort.org/documents/snort-users-manual-2-9-16).

### To Delete


- give an intro to snort
	- tell how to quit (Ctrl-Z, not Ctrl-C)
- have them turn on snort, as shown at https://www.rapid7.com/blog/post/2017/01/11/how-to-install-snort-nids-on-ubuntu-linux/ in the "Testing Snort" section (but don't add the rules yet)
	- command on gateway: `snort -A console -q -c /etc/snort/snort.conf -i eth0`
- have them run nmap, and see the results
- add rules on that page
	- run nmap and see the results
	- add run_malware and see the results (perhaps add more or less rules)
- labtainer part 4.3: write a bad rule
- write more rules, getting more complicated each time
	- ...
	- ...
- have them write rules to detect what is going on in run_malware
- have them read pcaps
	- the ones from jason
	- malware ones online from [here](https://wiki.wireshark.org/SampleCaptures#Other_Sources_of_Capture_Files) or [here](https://www.netresec.com/?page=pcapfiles)
	- one they made
- have them write a rule for something, and submit it


### Changelog

Any changes to this page will be put here for easy reference.  Typo fixes and minor clarifications are not listed here.  So far there aren't any significant changes to report.


### Introduction

<img src="../../docker/network_compact_for_dns.svg" style="float:right;width:60%">

Recall our network setup, which is shown to the right.  We will always run Snort on *gateway*, listening to eth0 (the green link).  All of our communications with the Internet will come from *inner*, and as it is routed through *gateway*, we will see the results in Snort.

#### Running Snort

On *gateway*, run snort via the following command:

```
snort -A console -q -c /etc/snort/snort.conf  -k none -i eth0
```

It will appear to hang -- it's waiting for suspicious network packets to display.  If you want to exit Snort, Ctrl-C may not work; if not, hit Ctrl-Z, an then kill the process (`kill -9 %1`).

The options we used are:

- `-A console`: print the alerts to the console (the screen)
- `-q`: suppress some extra output that we don't care about
- `-c /etc/snort/snort.conf`: what configuration file to use; we'll see this more shortly
- `-k none`: do not compute checksums, which is necessary in our particular Docker environment
- `-i eth0`: what interface to listen on

Currently Snort will only display output if there is something suspicious.  To show this, enter each of these commands from *inner* (some will not work; that's intentional):

```
ping -c 1 firewall
ftp firewall # and then logout
telnet firewall
```

On *gateway*, you should have seen no output.

#### Using Snort

Let's see what Snort can output.  From *inner*, enter `nmap firewall`.  This is caught by a rule, and there should be output on *gateway*:

```
04/16-12:09:26.272257  [**] [1:469:3] ICMP PING NMAP [**] [Classification: Attempted Information Leak] [Priority: 2] {ICMP} 192.168.200.3 -> 192.168.100.1
04/16-12:09:26.298485  [**] [1:1421:11] SNMP AgentX/tcp request [**] [Classification: Attempted Information Leak] [Priority: 2] {TCP} 192.168.200.3:56665 -> 192.168.100.1:705
04/16-12:09:26.300319  [**] [1:1418:11] SNMP request tcp [**] [Classification: Attempted Information Leak] [Priority: 2] {TCP} 192.168.200.3:56665 -> 192.168.100.1:161
```

Try running the `run_malware` program that you used in the [Wireshark assignment](../wireshark/index.html) ([md](../wireshark/index.md)); recall that it is only installed on *inner*.  While there are multiple things that the `run_malware` program does, only one of them is caught by the current set of Snort rules -- sending a large amount of data through an ICMP packet, like you did in the [Ping Shell Commands assignment](../pingcmnd/index.html) ([md](../pingcmd/index.md)).  You should have seen output such as:

```
04/16-12:11:13.817900  [**] [1:499:4] ICMP Large ICMP Packet [**] [Classification: Potentially Bad Traffic] [Priority: 2] {ICMP} 192.168.200.3 -> 192.168.100.1
04/16-12:11:13.818019  [**] [1:499:4] ICMP Large ICMP Packet [**] [Classification: Potentially Bad Traffic] [Priority: 2] {ICMP} 192.168.100.1 -> 192.168.200.3
```

Recall that you should type "quit" to exit the `run_malware` program.

### Snort rules

If Snort is still running from the previous section, you should stop it (hit Ctrl-Z, then enter `kill -9 %1`).


#### Snort Rule Configuration

Snort has a series of rules that it uses to analyze network traffic.  The set of rules we are using is the "community" set, which means it is free.  There are also various sets of rules that one has to pay for; we won't look into those in this assignment.

The configuration file that contains the rules is in `/etc/snort/snort.conf`.  We told Snort to use that file when we launched Snort, above.  That file is long and complicated, and not something we need to look at -- but you should know it exists.  Among other things, it tells Snort that the rule sets are in `/etc/snort/rules/`.  If you look in that directory, you will see a number of files, all containing many Snort rules.

We are going to look at `local.rules` -- this file is for rules specific to that machine or network, as opposed to rules that everybody will want to use.  Currently the file looks like this:

```
# $Id: local.rules,v 1.11 2004/07/23 20:15:44 bmc Exp $
# ----------------
# LOCAL RULES
# ----------------
# This file intentionally does not come with signatures.  Put your local
# additions here.
```


#### Snort Rule Format

The general format for a Snort rule is:

```
<action> <proto> <src_addr> <src_port> <dir> <dest_addr> <dest_port> <rule_options>
```

The components in more detail:

- `<action>`: what Snort should do if this rule matches.  There are 5 total actions, the other four being `dynamic`, `pass`, `log`, and `activate`.  We are only going to look at alert actions in this assignment.
- `<proto>`: the protocol for the rule; supported protocols are `tcp`, `udp`, `icmp`, or `ip`.  One can also use *services* as well, such as `ssl`, `http`, etc.
- `<src_addr>`: the IP address that this originates from; can also be `any`.  This can also be `$HOME_NET`, which is the current network Snort is being run from.  This is either obtained from the `snort.conf` file or auto-detected.
- `<src_port>`: the port that this originates from; can also be `any`.
- `<dir>`: what direction the packet is moving.  Options are `->` (source to destination) and `<>` (bi-directional).  If one wanted to use the equivalent of `<-`, one would just swap the source and destination fields and use `->`.
- `<dest_addr>`: the IP address that this is going to; can also be `any`.
- `<dest_port>`: the port that this is going to; can also be `any`.
- `<rule_options>`: how to identify the item, and other actions Snort should perform.  It is a semi-colon separated list of key-value pairs, all enclosed in parentheses.  You can see all of the rule options [here](http://manual-snort-org.s3-website-us-east-1.amazonaws.com/node27.html) (in the various sub-pages therein) or in the [Snort documentation PDF](https://www.snort.org/documents/snort-users-manual-2-9-16) staring in section 3.3 (page 185).  The relevant options used above are:
	- `msg`: print the message out to the console (and, possibly, the log).
	- `sid`: the signature ID of the rule, which must be unique.  This is so both Snort and various plug-ins can identify rules easily.
	- `rev`: the revision of the rule, as one often has to update the rules.  This needs to be used with the `sid` option.


#### Writing Snort Rules

Recall that before, when we run a number of non-suspicious commands (FTP, ping, and telnet), Snort did not report anything to the console.  We are going to change that by entering the following rules into that file:

```
alert tcp any any -> $HOME_NET 21 (msg:"FTP connection attempt"; sid:1000001; rev:1;) 
alert icmp any any -> $HOME_NET any (msg:"ICMP connection attempt"; sid:1000002; rev:1;) 
alert tcp any any -> $HOME_NET 80 (msg:"TELNET connection attempt"; sid:1000003; rev:1;)
```

To check your rules, run `snort -T -i eth0 -c /etc/snort/snort.conf`.  There will be a lot of output, but the last two lines should look like the following:

```
Snort successfully validated the configuration!
Snort exiting
```

If you see that, then your rules are all valid.

Now start Snort on *gateway*, and run the commands from above on *inner*:

```
ping -c 1 firewall
ftp firewall # and then logout
telnet firewall
```

You should now see this output on *gateway*:

```
04/16-13:11:21.907803  [**] [1:1000002:1] ICMP connection attempt [**] [Priority: 0] {ICMP} 192.168.200.3 -> 192.168.100.1
04/16-13:11:21.907863  [**] [1:1000002:1] ICMP connection attempt [**] [Priority: 0] {ICMP} 192.168.100.1 -> 192.168.200.3
04/16-13:11:24.588946  [**] [1:1000001:1] FTP connection attempt [**] [Priority: 0] {TCP} 192.168.200.3:33632 -> 192.168.100.1:21
04/16-13:11:27.179403  [**] [1:1000003:1] TELNET connection attempt [**] [Priority: 0] {TCP} 192.168.200.3:39582 -> 192.168.100.1:23
```

Note that we see the ICMP packet twice, as the first is the ping, and the second is the ping response.  Unlike the other two rules, any ICMP packet -- in either direction -- qualifies for that rule, so both are printed.

### Pcap Analysis

#### How to analyze pcap files

You can also run Snort on a saved pcap file using the `-r` option.

To test this, we are going to analyze two pcaps of malware from [wireshark.org](https://wiki.wireshark.org/SampleCaptures#Other_Sources_of_Capture_Files): the Slammer worm ([slammer.pcap](https://wiki.wireshark.org/uploads/__moin_import__/attachments/SampleCaptures/slammer.pcap)) and a DNS remote shell ([dns-remoteshell.pcap](https://wiki.wireshark.org/uploads/__moin_import__/attachments/SampleCaptures/dns-remoteshell.pcap)).  To download them onto your Docker container, run:

```
wget https://wiki.wireshark.org/uploads/__moin_import__/attachments/SampleCaptures/slammer.pcap
wget https://wiki.wireshark.org/uploads/__moin_import__/attachments/SampleCaptures/dns-remoteshell.pcap
```

We are going to use the same Snort command as before, but instead of specifying an interface (`-i eth0`), we are going to specify a pcap file (`-r slammer.pcap`).  Thus, the command for slammer.pcap would be:

```
snort -A console -q -c /etc/snort/snort.conf  -k none -r slammer.pcap
```

#### Analysis with Snort

In Canvas Files are two pcaps, named `snort-uva-attack-1.pcap` and `snort-uva-attack-2.pcap`.  Both of these were actual malware attacks against UVA.  Using Snort and Wireshark, you need to analyze these two pcaps.  You will probably want to use Snort to figure out some basic information, and then investigate further using Wireshark.

The questions you should answer are: 

1. What was the attack that is in the pcap?  If the attack has an actual name (and CVE number), then use that.  Otherwise, a description of how the attack worked is sufficient.
2. What was the result of the attack?  Specifically, was it successful?  If so, what were the results of the attack?  If not, what would have been the result of the attack had it been successful?

The answer to this is to be in prose (a normal paragraph), and is limited to 250 characters.  The answer will go in the appropriate field of [snort.py](snort.py.html) ([src](snort.py)).  Note that if you cut-and-paste it from another editor, it may paste in smart quotes, which will cause the Gradescope submission checker to report an error (that it's a utf-8 file, not an ascii file).


### Writing Rules

The `run_malware` program has five different "things" it will transmit over the network.  Four are various types of suspicious "attacks" (they aren't really attacks, but look like they could be).  The ICMP exfiltration was already caught by the default Snort rules, which you saw above, so there are three more.  There is also a red herring network transmission (something that is not an attack, but meant to distract you from the actual attacks).  

Using Wireshark, you should figure out what the other three attacks are, and write a Snort rule that will catch each one of them.  You can search the web for example Snort rules as you develop these rules.  You do not need to write a rule for the red herring.

For each of the three other types of attacks, you will have to enter a brief description of the attack, as well as the full Snort rule, into the appropriate fields of [snort.py](snort.py.html) ([src](snort.py)).  It does not matter the order that you enter the rules, although the description must obviously match the Snort rule.


### Submission

You will be submitting an edited version of [snort.py](snort.py.html) ([src](snort.py)).














