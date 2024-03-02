Network Security: UVA specific material, spring 2024
==================================================

[Go up to the main NWS readme](../readme.html) ([md](../readme.md))

Much of the rest of this repository is meant to be generic to anybody who has a class such as this one. This page contains details specific to the specific version of the course at the University of Virginia.

------------------------------------------------------------

Links
-----

There are a number of links and other parts of this course that are **NOT** included in this repository. They are:

- Any concerns you have should be handled via a support request; the link is on the [Canvas landing page][1]
- Assignment submission is through the Gradescope tool in Canvas
- The Piazza forum for this course; Canvas can log you in directly -- the Canvas tool link is [here](https://canvas.its.virginia.edu/courses/92875/external_tools/21)
- [Anonymous feedback through Canvas](https://canvas.its.virginia.edu/courses/92875/external_tools/5876)

<!-- no longer available in canvas:

- ~~[Email list archive](...): not a canvas tool~~
- ~~[Anonymous feedback](...): not a canvas tool~~

--> 

The parts of this course that are in this repo are:

- [Course syllabus](syllabus.html) ([md](syllabus.md))
- [Daily announcements](daily-announcements.html#/)
- [Homework policies page](hw-policies.html) ([md](hw-policies.md))
- [Final course grade determination](grades.html) ([md](grades.md))


Readings
--------

<!-- All scholarly articles (such as from the ACM digital library) can be obtained from free from any UVA wireless network. Some of them you will *NOT* be able to get it for free from your home Internet provider such as Comcast (unless you live in a UVA dorm, of course) without using a UVA VPN. -->

All readings are due by the start of lecture that day. You should expect there to be in-class quizzes on each reading.  The list of readings, and when they are due, are on the [Canvas landing page][1].


Homeworks
---------

Reading assignments are due by the start of the lecture that day, and all other homeworks are due by the end of the day of the due date given -- this means by 11:59:59 pm. The late policies are discussed in the [homework policies page](hw-policies.html) ([md](hw-policies.md)). Submission is through the Gradescope Canvas tool -- all submissions should open up 2 days (i.e., 48 hours) prior to the due date/time. The larger ("P") homeworks are due on Tuesdays by the end of the day; the smaller homeworks will have varying due days.


#### Larger Programming Homeworks

All of the programming homeworks are due by the end of the day (11:59:59 pm). To avoid having the due dates having to be listed in too many places, the homeworks and their due dates are not shown here. The homeworks themselves can be seen on the [Homeworks page](../hws/index.html) ([md](../hws/index.md)) -- but please don't start on one until it's announced in class that it is ready! You can see the due dates in the [daily announcements](daily-announcements.html#/) and the [Canvas landing page][1].


#### Smaller Homeworks

Readings are due by the start of lecture on that day; all other homeworks are due by the end of the day (11:59:59 pm).



Course calendar
---------------

The smaller ("S") homeworks are usually due Friday, unless otherwise noted.  The larger programming ("P") homeworks are due Tuesday.  All homeworks are due by the end of the day (11:59:59 pm).

| Week<br># | Week&nbsp;of<br>Monday | Lecture<br>days | P HWs due Tue | S HWs due, usually <br> due Fri | Readings due | Expected Topics | Actual Progress |
|---|---|---|---|---|---|---|---|
| 1 | Jan 15 | W,F | (none) | (none) | (none) | [Introduction](../slides/introduction.html#/); [Physical layer](../slides/physical-layer.html#/) | Wed: introduction (finished); Fri: physical layer (finished) |
| 2 | Jan 22 | M,W,F | (none) | Survey (due Tue), [Docker](../hws/docker/index.html) ([md](../hws/docker/index.md)) (due Fri) | (none) | [Data link layer](../slides/link-layer.html#/) | Mon: link layer to 5.5; Wed: link layer to 8.5; Fri: finished link layer |
| 3 | Jan 29 | M,W,F | (none) | [Linux tutorial](../hws/linux/index.html) ([md](../hws/linux/index.md)) (due Tue), [Network commands](../hws/netcmds/) (due Fri) | Du, chap 3 (IP); 22 pp | [Network layer](../slides/network-layer.html#/) | Mon: network layer to 5.3; Wed: network layer to 6.3; Fri: transport layer to 5.15, packets to 5.4 |
| 4 | Feb 5 | M,W,F | ARP | Metasploitable hacks, part 1 | Du, chap 5 (transport layer), sections 6.1-6.3 of chapter 6 (TCP attacks); 25 pp | [Packet capture & analysis](../slides/packets.html#/); [Transport layer](../slides/transport-layer.html#/) | Mon: finished network layer, packets to 4.4; Wed: packets to 5.2, transport-layer to 5.3; Fri: ... |
| 5 | Feb 12 | M,W,F | Routing | Metasploitable hacks, part 2 | | [Transport layer](../slides/transport-layer.html#/); [Firewalls & evasion](../slides/firewalls.html#/) | Mon: finished packets; transport-layer to 7.11; Wed: transport layer to 9.4; Fri: finished transport layer, firewalls to 3.3 |
| 6 | Feb 19 | M,W,F | Wireshark | Web of trust, week 1 | | [Encryption](../slides/encryption.html#/) | Mon: firewalls to 7.6; Wed: finished firewalls, encryption to 3.8; Fri: encryption to 4.4 |
| 7 | Feb 26 | M,W,F | (midterm on Wed) | Web of trust, week 2 | | [Encryption](../slides/encryption.html#/) | Mon: encryption to 5.13; Wed: midterm; Fri: [WoT](../hws/weboftrust/index.html) work day |
| 8 | Mar 4 |  |  |  | Spring break (no classes) |  |  |
| 9 | Mar 11 | M,W,F | TCP reconstruction | Firewall configuration |  | Presentation layer; Application layer |  |
| 10 | Mar 18 | M,W,F | Xmas scans | TBD |  | TCP shells & botnets; WWW exploits |  |
| 11 | Mar 25 | M,W,F | Protocol | TBD |  | WWW exploits; Network monitoring |  |
| 12 | Apr 1 | M,W,F | TCP shell | TBD |  | Obtaining and using access; BGP |  |
| 13 | Apr 8 | M,W,F | Network monitoring | TBD |  | Network attacks |  |
| 14 | Apr 15 | M,W,F | BGP | TBD | TBD | DNS; Heartbleed |  |
| 15 | Apr 22 | M,W,F | DNS | TBD | TBD | Trojans, rootkits, ransomware; Scanning & fuzzing; Social Engineering |  |
| 16 | Apr 29 | M | SSH MITM | (none) | (none) | Conclusion |  |

[1]: https://canvas.its.virginia.edu/courses/92875
