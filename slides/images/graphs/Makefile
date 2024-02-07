SEDI = sed -i
ifeq ($(shell uname),Darwin)
        SEDI=sed -i .sedbak
endif

SVGS=nat tcp_open tcp_close

graph:
	dot -Tsvg -O nat.dot
	/bin/mv nat.dot.svg nat.svg
	dot -Tsvg -O tcp.dot
	/bin/mv tcp.dot.svg tcp_open.svg
	/bin/mv tcp.dot.2.svg tcp_close.svg
	$(SEDI) s_href=\"./_href=\"`pwd`/_g *.svg
	for x in $(SVGS); do convert $$x.svg $$x.png; done
	for x in $(SVGS); do cwebp -lossless -o $$x.webp $$x.png; done

doc:
	touch index.md
	cd ..; make -s
	source-highlight -d *.sh

clean:
	for x in $(SVGS); do /bin/rm -f $$x.svg $$x.png; done
	/bin/rm -f *.png
