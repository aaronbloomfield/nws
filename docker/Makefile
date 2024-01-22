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
	mv network.dot.4.svg network_compact_for_arp_spoofed.svg
	convert network_compact_for_arp_spoofed.svg network_compact_for_arp_spoofed.png
	mv network.dot.5.svg network_compact_for_arp_normal.svg
	convert network_compact_for_arp_normal.svg network_compact_for_arp_normal.png

clean:
	/bin/rm -f network*.svg network*.png
