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
