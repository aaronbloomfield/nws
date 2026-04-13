.SUFFIXES: .md .html
SED=sed -i
ifeq ($(shell uname),Darwin)
	SED=sed -i .sedbak
endif

markdown:
	@find . | grep -e "\.md$$" | grep -v reveal.js | grep -v node_modules | sed s/.md$$/.html/g | awk '{print "make -s "$$1}' | bash
	@/bin/cp -f readme.html index.html

touchall:
	find . | grep "\.md$$" | awk '{print "touch "$$1}' | bash

.md.html:
	pathprefix=`echo $< | tr -d -c '/' | sed -r 's/\//..\//g'` && \
		pandoc --template `git rev-parse --show-toplevel`/pandoc-template.html --standalone --metadata lang="en" -V "pagetitle:$$(head -1 $<)" -H tabs.js -f markdown -c $$pathprefix"markdown.css" --columns=9999 -t html5 -o $@ $<
	@echo wrote $@

all-source-highlight:
	custom-source-highlight.sh */*.py */*/*.py hws/*/*.js */*/*.c docker/*.sh
	/bin/rm -f hws/maketabs.py.html
