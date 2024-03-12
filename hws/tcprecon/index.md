TCP file re-assembly
=================

[Go up to the NWS HW page](../index.html) ([md](../index.md))

### Overview

In this assignment you will be reconstructing files transferred in TCP streams.  Any http:// connection will request a number of files -- .html files, images, scripts, and CSS style sheets, to name a few.  Given a stream of network data, you will reconstruct the images and save them as files.

We will be using Python, and Scapy, for this.  As Python (and Scapy) are rather slow, it may not be able to keep up with a real-time TCP stream.  Thus, we will only be analyzing pcap files.

You will be submitting your source code in `tcp_reconstruction.py`, as well as an edited version of [tcprecon.py](tcprecon.py.html) ([src](tcprecon.py)).


### Changelog

Any changes to this page will be put here for easy reference.  Typo fixes and minor clarifications are not listed here.  So far there aren't any significant changes to report.


### Introduction

You will only be analyzing HTTP streams.  Thus, if packet is not to or from port 80 (http's port), then the packet can be ignored.

#### Scapy and pcap files

Scapy has an interface to manage pcap files:

```
from scapy.all import *
pcap = rdpcap(sys.argv[1])
for pkt in pcap:
	print(pkt.summary())
```

Each `pkt` in the `for` loop is a regular Scapy packet (TCP in IP in Ether).  Although the `pcap` variable looks like a list, and can be indexed like a list, it's a slightly different type (`scapy.plist.PacketList`), and cannot perform some list modification operations.  You can create a list out of it (`pcapl = list(pcap)`) if you want to perform those operations.

#### HTTP via TCP streams

The way an HTTP request works is such:

- A new port is opened up on the client for *each* individual file transfer
	- Yes, this is inefficient, and web server wars between the major manufacturers have erupted over optimizations to this
	- Note that the relevant port is the client's source (the server's destination port)
- An request, following the HTTP protocol (see below), is sent from the client to the server's port 80
	- An example TCP *request* data will be something like this: `GET /path/to/filename.ext HTTP/1.1\r\nHost: ...\r\n...\r\n`
		- This looks like a response (it starts with "GET "), but because it goes *to* port 80, it's a request, and we are ignoring it for this assignment
	- You would save that file as `output/filename.ext` once you have downloaded all the parts
		- To ensure that the output/ directory is present, call `os.system("mkdir -p output")`; this will not cause an error if the output/ directory already exists
	- You can identify this "request" packet because (1) it's the first TCP packet in the stream for the relevant port (the client's port) that has a payload, and (2) it starts with "GET "
	- If there is just a slash in the URL, or ends in a slash (for example: `GET / HTTP/1.1` or `GET /subdir/ HTTP/1.1`), you should append `index.html` to it (`/index.html` or `/subdir/index.html`, respectively)
		- If one requests `subdir/index.html` via just `subdir`, there is a redirect -- how to handle these are described below
- An ACK is sent back from the server to the client, usually without any packet data
- A series of TCP packets are sent containing the data itself
	- The relevant port is still the client's source port (the server's destination port)
	- The source source port is 80
- The FIN flag is set in the last packet of the stream
- The downloaded binary blob will have the HTTP headers at the top, and those are not part of the downloaded file.  The headers are text, and there is a `\r\n\r\n` separating the headers from the binary content.  See the example below.
- Many files will load other files -- an .html document, for example, will load images, css, scripts, etc.; these will each be a separate request (on a separate source port)

A sample http request (sent from the client to the server) is below.  Note that the separators between each line are `\r\n`, and the ending separator is `\r\n\r\n`.  This was a request made to [http://www.virginia.edu](http://www.virginia.edu).  It promptly redirected to https, but the regular http request is still illustrative.

```
GET / HTTP/1.1
Host: www.virginia.edu
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:122.0) Gecko/20100101 Firefox/122.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Connection: keep-alive
Upgrade-Insecure-Requests: 1
DNT: 1
Sec-GPC: 1
```

A HTTP response is shown below.  This is to a different request, that did not redirect to https.  This for a PNG file download (which had the filename extension of .jpg for some unknown reason).  You can see the HTTP headers in a very readable form.  The separator is `\r\n\r\n`, which just appears as a newline below.

```
HTTP/1.1 200 OK
Date: Sun, 18 Feb 2024 14:16:04 GMT
Server: Apache/2.4.6 (CentOS)
Last-Modified: Thu, 24 Feb 2022 14:55:26 GMT
ETag: "119f7-5d8c4c5b95380"..Accept-Ranges: bytes
Content-Length: 72183
X-Clacks-Overhead: GNU Terry Pratchett
Access-Control-Allow-Origin: *
Connection: close
Content-Type: image/png
```

The response is shown below in `hexdump -C` format.  You can see the start of the PNG file after the headers.  The separator (`\r\n` between lines, and `\r\n\r\n` to end the header) in hex, which is `0d 0a 0d 0a`.  The end-of-header separator is the last byte of the 0x00000130 line, and the first three bytes of the 0x00000140 line.  The PNG data itself starts on the 4th byte of the 0x00000140 line.

```
00000000  48 54 54 50 2f 31 2e 31  20 32 30 30 20 4f 4b 0d  |HTTP/1.1 200 OK.|
00000010  0a 44 61 74 65 3a 20 53  75 6e 2c 20 31 38 20 46  |.Date: Sun, 18 F|
00000020  65 62 20 32 30 32 34 20  31 34 3a 31 36 3a 30 34  |eb 2024 14:16:04|
00000030  20 47 4d 54 0d 0a 53 65  72 76 65 72 3a 20 41 70  | GMT..Server: Ap|
00000040  61 63 68 65 2f 32 2e 34  2e 36 20 28 43 65 6e 74  |ache/2.4.6 (Cent|
00000050  4f 53 29 0d 0a 4c 61 73  74 2d 4d 6f 64 69 66 69  |OS)..Last-Modifi|
00000060  65 64 3a 20 54 68 75 2c  20 32 34 20 46 65 62 20  |ed: Thu, 24 Feb |
00000070  32 30 32 32 20 31 34 3a  35 35 3a 32 36 20 47 4d  |2022 14:55:26 GM|
00000080  54 0d 0a 45 54 61 67 3a  20 22 31 31 39 66 37 2d  |T..ETag: "119f7-|
00000090  35 64 38 63 34 63 35 62  39 35 33 38 30 22 0d 0a  |5d8c4c5b95380"..|
000000a0  41 63 63 65 70 74 2d 52  61 6e 67 65 73 3a 20 62  |Accept-Ranges: b|
000000b0  79 74 65 73 0d 0a 43 6f  6e 74 65 6e 74 2d 4c 65  |ytes..Content-Le|
000000c0  6e 67 74 68 3a 20 37 32  31 38 33 0d 0a 58 2d 43  |ngth: 72183..X-C|
000000d0  6c 61 63 6b 73 2d 4f 76  65 72 68 65 61 64 3a 20  |lacks-Overhead: |
000000e0  47 4e 55 20 54 65 72 72  79 20 50 72 61 74 63 68  |GNU Terry Pratch|
000000f0  65 74 74 0d 0a 41 63 63  65 73 73 2d 43 6f 6e 74  |ett..Access-Cont|
00000100  72 6f 6c 2d 41 6c 6c 6f  77 2d 4f 72 69 67 69 6e  |rol-Allow-Origin|
00000110  3a 20 2a 0d 0a 43 6f 6e  6e 65 63 74 69 6f 6e 3a  |: *..Connection:|
00000120  20 63 6c 6f 73 65 0d 0a  43 6f 6e 74 65 6e 74 2d  | close..Content-|
00000130  54 79 70 65 3a 20 69 6d  61 67 65 2f 70 6e 67 0d  |Type: image/png.|
00000140  0a 0d 0a 89 50 4e 47 0d  0a 1a 0a 00 00 00 0d 49  |....PNG........I|
00000150  48 44 52 00 00 03 aa 00  00 04 7a 08 06 00 00 00  |HDR.......z.....|
00000160  42 e5 8a bf 00 00 00 04  73 42 49 54 08 08 08 08  |B.......sBIT....|
00000170  7c 08 64 88 00 00 00 09  70 48 59 73 00 00 5c 46  ||.d.....pHYs..\F|
00000180  00 00 5c 46 01 14 94 43  41 00 00 00 19 74 45 58  |..\F...CA....tEX|
00000190  74 53 6f 66 74 77 61 72  65 00 77 77 77 2e 69 6e  |tSoftware.www.in|
000001a0  6b 73 63 61 70 65 2e 6f  72 67 9b ee 3c 1a 00 00  |kscape.org..<...|
000001b0  20 00 49 44 41 54 78 9c  ec dd 77 98 65 55 95 b0  | .IDATx...w.eU..|
000001c0  f1 75 3a 40 03 0d dd 34  39 23 41 32 22 8a 82 08  |.u:@...49#A2"...|
000001d0  28 41 30 47 18 47 31 ce  a8 a0 62 0e a3 a3 0e 86  |(A0G.G1...b.....|
```

### Response Codes

Every HTTP request has a *response code* in the reply.  You can see a [list of all the http response codes](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes).

Response code 200 ("OK") means that the request was valid, and the data for the file follows the header.  These are the ONLY response codes that we will be considering.  Any other response code should be ignored.

A redirect is a different type of response code.  If you were to request the URI `/subdir` or `/subdir/`, the web server would likely redirect the browser to `/subdir/index.html` via a 302 ("found" or "moved temporarily") response code.  As this is not a 200 response code, we can ignore that response.  HOWEVER, not all web browsers do this.  

Assuming that the response is a 200 -- the only ones we are considering -- if the URI ends in a slash, then append `index.html` to it.  If the URI is a directory, but there is no redirect (for example, the request is for `/subdir`, and the response is a 200 ("OK") with data, but does not redirect), then you should save the file as 'subdir'.

The response code is in the HTTP response header.  From the example above, the first few lines of the response header is:

```
HTTP/1.1 200 OK
Date: Sun, 18 Feb 2024 14:16:04 GMT
Server: Apache/2.4.6 (CentOS)
...
```

The "200" in the first line is the response code.  Note that the HTTP version can vary, but will always be a number (possibly an integer).  A space separates the `HTTP/<ver>` and the response code.


### Your Task

Your task is to write a program called `tcp_reconstruction.py`.  Given a pcap file as a command-line parameter, it will read through the file and save any files transferred via the HTTP protocol.  Some requirements:

- You are only considering responses with HTTP response code 200 ("OK")
- All files should be saved in an `output/` sub-directory; you can create it via `os.system("mkdir -p output")`
- The file name should be the same as what it is in the HTTP header
- Files with long path names (`/long/winded/path/to/file/named/foo.txt`) should just be saved as the filename (`output/foo.txt`) -- you should not try to reconstruct the directory structure in our `output/` directory
- If you reach the end of the pcap file, and not all of the packets are present (it got cut off before finishing transmission, for example), then don't write the file to disk
	- Rephrased: you should only write a file to disk when you see the FIN packet
- If a file already exists in the `output/` directory, either from a previous run or because two files downloaded have the same name, you should just overwrite the existing file with the new one
- You should output exactly one line for each file extracted; that line should be of the form: `Wrote index.html of length 39350`
	- If you have the file name in `filename`, and the size in `size`, the following print statement will produce the correct output: `print(f"Wrote {filename} of length {size}")`
	- If there are multiple files in a given pcap, it does not matter the order that you print out these lines

A few clarifications:

- The URI (and thus the filename) are only in the HTTP *request*, which goes *to* port 80 and comes from the client's open port
- The response code is in the first packet of the HTTP *response*, which comes *from* port 80 and goes to the client's open port
- You can match these up by the client's port number

You may make a number of assumptions about the data for this assignment:

- The files provided will be valid pcap files, and your program will always be given one (and only one) existing pcap file when run, as a command line parameter
- We are going to test your code on various pcap files, but we are not going to try to purposely create malicious packets.  All the packets will be following the HTTP protocol
- All the pcap files will easily fit into memory -- we are not going to test this with very large pcap files
- All of the files saved to disk will be relatively small -- no more than, say, 10 Mb per pcap file, so you do not have to worry about disk space issues
- You may assume that all the TCP packets for a given file will be in order in the pcap file; however, the TCP packets for different files may be interleaved with each other
	- While this is not a reasonable assumption in practice (that the packets are in order), it makes our assignment much easier to implement while still teaching the same concepts
- You may assume that none of the IP packet headers have options -- in other words, all IP packet headers are exactly 20 bytes; this is not something you can assume for the TCP headers, though

#### Scapy and TCP payloads

It is surprisingly annoying in Scapy to determine if a TCP packet has a payload, as if it does not, trying to access `packet[TCP].load` will thrown an exception.  The following function may make this easier:

```
def pkt_has_tcp_load(pkt):
	try:
		x = pkt[TCP].load
		return True
	except:
		return False
```

#### Live Traffic

This assignment is dealing with pcap files.  To have your program process live TCP data, you would have Scapy call your function via the `sniff()` functionality, as shown [here](slides/packets.html#/2/8).  This is not required for this assignment, though -- we are only using pcap files.


### Output

For each file written to the output/ directory, you should print one line:

```
Wrote index.html of length 39350
```

Please check that the formatting is correct, as the auto-grader is going to look for that exact output!  If you have the file name in `filename`, and the size in `size`, the following print statement will produce the correct output:

```
print(f"Wrote {filename} of length {size}")
```

An example execution run is as follows:

```
$ python3 tcp_reconstruction.py andromeda-img.pcap
Wrote Andromeda_IAU.png of length 259492
$
```

If there were more files in the pcap file than that one, each file would print out a separate line of output.


### Testing

There are two (at least) pcap files provided for testing.  Due to their size, they are in Canvas' files, and not in the repo.

The first, andromeda-img.pcap, will yield exactly one image ([this one](https://commons.wikimedia.org/wiki/File:Andromeda_IAU.svg), in fact).  The file's name is `Andromeda_IAU.png`, the file size is 259,492 bytes, and it's resolution is 1000x871 pixels (not the size of the original).

The second, www.phys.virginia.edu.pcap, is from an http request to [http://www.phys.virginia.edu](http://www.phys.virginia.edu).  It yields 25 files, which are shown below.  The output below is sorted alphabetically for ease of finding the files therein, and your output order is expected to be different.

```
Wrote ats2mk.300x200.png of length 345726
Wrote bss2d.300x200.png of length 332306
Wrote cas8m.300x200.png of length 312153
Wrote condmat_sem_committee_event.png of length 209480
Wrote favicon.ico of length 1150
Wrote favicon.ico of length 1150
Wrote font-awesome.css of length 28713
Wrote grav_sem_committee_event.png of length 116846
Wrote hep_sem_committee_event.png of length 518964
Wrote IMGS0244-1400x800.jpg of length 1305475
Wrote index.html of length 39350
Wrote ky5t.300x200.png of length 316928
Wrote leaflet.css of length 14268
Wrote leaflet.fullscreen.css of length 994
Wrote Leaflet.fullscreen.min.js of length 3677
Wrote leaflet.js of length 142601
Wrote physics-inherited.css of length 60040
Wrote physics-large-newbox.svg of length 3550
Wrote physics-logo-blue-orange-white-clean-square-300x200.png of length 34579
Wrote physics-logo-white.png of length 72183
Wrote physics.css of length 10841
Wrote ps5nw.300x200.png of length 327774
Wrote speakers_committee_event.png of length 25795
Wrote uva-large-newbox.svg of length 7304
Wrote yfo7rax.css of length 9373
```

### Submission

You will be submitting your source code in `tcp_reconstruction.py`, as well as an edited version of [tcprecon.py](tcprecon.py.html) ([src](tcprecon.py)).

