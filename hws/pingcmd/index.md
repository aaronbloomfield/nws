Ping Shell Commands
=================

[Go up to the NWS HW page](../index.html) ([md](../index.md))

### Overview

In this assignment you will write a simple remote shell using ICMP.  This assignment will use the Scapy Python package.  The client will send messages as the payload (content) in an ICMP ping message.  The server will execute the commands, and return the output to the client.

You will be submitting your source code in `ping_shell.py` as well as an edited version of [pingcmd.py](pingcmd.py.html) ([src](pingcmd.py])).


### Changelog

Any changes to this page will be put here for easy reference.  Typo fixes and minor clarifications are not listed here.  So far there aren't any significant changes to report.


### Remote Shell

#### The Task

You are going to write a Python program that handles both the client side and the server side of this remote shell.  On the client side, if the user enters any input, it is sent as the payload of an ICMP packet to the server, which executes the command, and then sends the output back to the client, which will display that output.

The server only listens for input from the client.  If it receives "quit" from the client, it will exit.  Any other input is executed, and the output is sent back to the client.  You are welcome to have the server also listen for "quit" and also exit then, if that's easier (since it mirrors how the client works).  But the server should quit if "quit" is entered on the client.

When the program starts, it will be given three command line parameters.  You can assume that the command line parameters will always be correct -- both in how many are present, and in their values.

- An example program invocation is: `ping_shell.py server eth1 192.168.100.101`
	- The first parameter is either "server" or "client", so that your program can run in server mode or client mode
	- The second parameter is which interface to listen to.
	- The third parameter is the IP of the server (always), and is guaranteed to be on the network of the interface in the second parameter.

Note that not all parameters are needed by each mode, but at least one mode needs each parameter.

Both sides should use the `sniff()` function from Scapy to sniff for ICMP packets.  This function blocks, so you will want to use threading to start the sniffing in another thread.  As some may not be familiar with threading in Python, here is a quick way to do it; you have to import the `threading` package:

```
def sniff_icmp_commands(pkt):
	# fill me in...
	pass

def start_sniffing(sig = None, frame = None):
	sniff(filter='icmp',iface=iface,prn=sniff_icmp_commands)

threading.Thread(target=start_sniffing, args=(), daemon=True).start()
```

The other thread (the one not sniffing) should receive input (via `input()`) until the user enters "quit".  Any input received, including "quit", will be sent to the server as an ping payload.  The client also quits on "quit".  Any response from the server will be displayed to the screen.  Note that, since any exit (from the "quit" command) needs to exit *both* threads, so use `os._exit(0)`.

You don't need to send the replies to the ping!  Let the operating system do that.  The client sends the command to the server in a ping-request (type=8), and the operating system sends the ping-reply (type=0).  Then the server sends the output in a new ping-request, and the operating system sends a ping-reply.

Your server should only capture standard output.  You do not need to worry about capturing standard error.  Nor do you have to worry about commands that might crash -- you can assume the commands will work properly.  Lastly, none of the commands will have output that exceeds the size that can fit into an ICMP packet.

### Sample output

#### Required output

The only required output is the result of executing the commands on the server; this output is displayed on the client.  The server does not output anything.  In the examples below you will also see the input typed to execute the commands as well.

You are welcome to put an extra blank line (or two or three) between the output displays on the client to make it more readable.

The first execution run below has debugging output to show the packet flow.  The second execution run has that output removed.  Your program should not have any extra debugging output!

#### Execution run 1

The first execution run has a lot of debugging information to help one trace how it works.  That debugging output always has the string "debug:" in it, includes time with milliseconds, and prints out a packet summary via `pkt.summary()`.

Client side:

```
root@outer2:/mnt# ./ping_shell.py client eth0 192.168.100.101                
debug: sniffing ICMP...
pwd
1707065371.9326015 	 debug: packet sent from client: IP / ICMP 192.168.100.102 > 192.168.100.101 echo-request 0 / Raw
1707065371.9560843 	 debug: client received response
/mnt

whoami
1707065386.3909845 	 debug: packet sent from client: IP / ICMP 192.168.100.102 > 192.168.100.101 echo-request 0 / Raw
1707065386.401789 	 debug: client received response
root

quit
root@outer2:/mnt# 
```

The server side:

```
root@outer1:/mnt# clear;./ping_shell.py server eth1 192.168.100.101^C
debug: sniffing ICMP...
1707065371.9186223 	 debug: server received packet: Ether / IP / ICMP 192.168.100.102 > 192.168.100.101 echo-request 0 / Raw 8 pwd
debug: server executing command: pwd
1707065386.3786142 	 debug: server received packet: Ether / IP / ICMP 192.168.100.102 > 192.168.100.101 echo-request 0 / Raw 8 whoami
debug: server executing command: whoami
root@outer1:/mnt# 
```

The server quit when it received "quit" from the client.

#### Execution run 2

This is similar to the previous command, but all the debugging output is removed.

Client-side:
```
root@outer2:/mnt# ./ping_shell.py client eth0 192.168.100.101
pwd
/mnt

whoami
root

quit
root@outer2:/mnt# 
```

Server side:

```
root@outer1:/mnt# ./ping_shell.py server eth1 192.168.100.101
quit
root@outer1:/mnt# 
```

Note that the server does not need to output anything.  Again, the server quit when it received "quit" from the client.


### Hints and Notes

There are Scapy commands to do a lot of the conversions that are needed.  For example, `get_if_addr(iface)` will get the IP address for that interface.  If you run the client on *outer2*, where `iface` is `eth0`, this will get 192.168.100.102.

Keep in mind that the interfaces are different on the different containers.  If you are using the 192.168.100.0/24 network, then the interface on *outer1* is `eth1`, and the interface for that network on *outer2* is `eth0`.

You can assume that any `ping` packets are meant for this program -- you don't have to worry about other IMCP ping packets.

The [ICMP section of the lecture slides](../../slides/network-layer.html#/icmp) show how to add a payload to an ICMP packet with Scapy, as well as how to retrieve one from an incoming ICMP packet.

The easiest way to get the output of a shell command run from Python is the `subprocess.check_output()` function.

You do not need to worry about shell commands that may hang or cause errors.  Nor do you have to worry about output that exceeds a packet length.

#### Links

We have seen a number of code examples that can be referenced for this assignment:

- [arp_mitm.py](../../slides/code/arp_mitm.py.html) ([src](../../slides/code/arp_mitm.py)), which shows how to use the `sniff()` function
- ICMP tunneling is shown [here](../../slides/network-layer.html#/5/5) and [here](../../slides/network-layer.html#/5/6)
- Threading, shown above, is [here](../../slides/packets.html#/2/8)
- Combining different network layers in Scapy is shown [here](../../slides/packets.html#/3/2)
- Sockets (not needed for this assignment, but included for completeness) are shown [here](../../slides/packets.html#/2/5)
- There is an ever-growing list of simple tasks (usually one liners) contained in the [scapy_howto.py](../../docs/scapy_howto.py.html) ([src](../../docs/scapy_howto.py)) file.

### Submission

You will be submitting your source code in `ping_shell.py` as well as an edited version of [pingcmd.py](pingcmd.py.html) ([src](pingcmd.py])).

