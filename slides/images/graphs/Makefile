SEDI = sed -i
ifeq ($(shell uname),Darwin)
        SEDI=sed -i .sedbak
endif

graph:
	@dot -Tsvg -O nat.dot
	@/bin/mv nat.dot.svg nat.svg
	@dot -Tsvg -O tcp.dot
	@/bin/mv tcp.dot.svg tcp_open.svg
	@/bin/mv tcp.dot.2.svg tcp_close.svg
	@/bin/mv tcp.dot.3.svg tcp_syn_attack.svg
	@/bin/mv tcp.dot.4.svg tcp_reset_attack.svg
	@#dot -Tsvg -O proxy.dot
	@#/bin/mv proxy.dot.svg proxy.svg
	@$(SEDI) s_href=\"./_href=\"`pwd`/_g *.svg
	@for x in `ls tcp*.svg nat*.svg proxy*.svg | sed s/.svg//g`; do convert $$x.svg $$x.png; done
	@for x in `ls tcp*.svg nat*.svg proxy*.svg | sed s/.svg//g`; do cwebp -quiet -lossless -o $$x.webp $$x.png; done
	@/bin/rm -f *.sedbak


tls:
	@dot -Tsvg -O tls.dot
	@/bin/mv tls.dot.svg tls-1.2.svg
	@/bin/mv tls.dot.2.svg tls-1.3.svg
	@$(SEDI) s_href=\"./_href=\"`pwd`/_g tls*.svg
	@for x in `ls tls*.svg | sed s/.svg//g`; do convert $$x.svg $$x.png; done
	@for x in `ls tls*.svg | sed s/.svg//g`; do cwebp -quiet -lossless -o $$x.webp $$x.png; done
	@/bin/rm -f *.sedbak

winauth:
	@dot -Tsvg -O winauth.dot
	@$(SEDI) s_href=\"./_href=\"`pwd`/_g winauth*.svg
	@for x in `ls winauth*.svg | sed s/.svg//g`; do convert $$x.svg $$x.png; done
	@for x in `ls winauth*.svg | sed s/.svg//g`; do cwebp -quiet -lossless -o $$x.webp $$x.png; done
	@/bin/rm -f *.sedbak

proxy:
	dot -Tsvg -O proxy.dot
	/bin/mv -f proxy.dot.svg proxy.svg
	$(SEDI) s_href=\"./_href=\"`pwd`/_g proxy.svg
	convert proxy.svg proxy.png
	cwebp -lossless -o proxy.webp proxy.png
	/bin/rm -f *.sedbak

doc:
	touch index.md
	cd ..; make -s
	source-highlight -d *.sh

clean:
	for x in $(SVGS); do /bin/rm -f $$x.svg $$x.png; done
	/bin/rm -f *.png
