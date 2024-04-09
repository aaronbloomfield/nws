doc:
	touch index.md
	cd ../..; make -s
	source-highlight -d *.py
	../maketabs.py

zip:
	for file in `ls *.yaml`; do ../../../autograder/autograder.py zip $$file; done
