doc:
	touch index.md
	cd ..; make -s
	source-highlight -d *.sh

graph:
	dot -Tsvg -O network.dot
	mv network.dot.svg network.svg
	convert network.svg network.png
	mv network.dot.2.svg network_compact.svg
	convert network_compact.svg network_compact.png
	mv network.dot.3.svg network_for_routing.svg
	convert network_for_routing.svg network_for_routing.png
	mv network.dot.4.svg network_compact_for_arp_spoofed_outer2.svg
	convert network_compact_for_arp_spoofed_outer2.svg network_compact_for_arp_spoofed_outer2.png
	mv network.dot.5.svg network_compact_for_arp_normal_outer2.svg
	convert network_compact_for_arp_normal_outer2.svg network_compact_for_arp_normal_outer2.png
	mv network.dot.6.svg network_compact_for_arp_normal_metasploit.svg
	convert network_compact_for_arp_normal_metasploit.svg network_compact_for_arp_normal_metasploit.png
	mv network.dot.7.svg network_compact_for_dns.svg
	convert network_compact_for_dns.svg network_compact_for_dns.png
	mv network.dot.8.svg network_for_sshmitm.svg
	convert network_for_sshmitm.svg network_for_sshmitm.png

sshmitm:
	dot -Tsvg -O network.dot
	mv network.dot.8.svg network_digram_for_sshmitm.svg
	convert network_digram_for_sshmitm.svg network_digram_for_sshmitm.png

clean:
	/bin/rm -f network*.svg network*.png
