doc:
	touch index.md
	cd ../..; make -s
	source-highlight -d *.py *.js
	../maketabs.py

zip:
	for file in `ls *.yaml`; do ../../../autograder/autograder.py zip $$file; done
