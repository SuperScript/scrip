include mk/help.mk

.SUFFIXES: .script .cast .gif

#_# bin/scrip
#_#   Build the scrip preprocessor from lib/scrip.sh
#_#
bin/scrip: lib/scrip.sh
	(echo '#!/bin/sh'; SCRIP_PATH=./lib /bin/sh lib/scrip.sh code lib/scrip.sh) > bin/scrip.new && chmod a+x bin/scrip.new && mv bin/scrip.new bin/scrip

#_# build
#_#   Build executables from src/*.sh
#_#
build: bin/scrip
	SCRIP_PATH=./lib sh -c 'for f in src/*.sh; do \
	  n="$${f%.sh}"; n="bin/$${n##src/}"; \
	  bin/scrip code "$$f" > "$$n.new" && chmod a+x "$$n.new" && mv "$$n.new" "$$n"; \
	done'

#_# .script.cast
#_#   Capture an asciinema recording of the source script
#_#
.script.cast: build
	rm -f "$@"
	bin/asciinema-script cast "$@" < $<

#_# .cast.gif
#_#   Create a .gif file from the .cast recording
#_#
.cast.gif: build
	bin/asciinema-script gif $< "$@"

#_# demos
#_#   Create a .gif file for each demos/*.script file
#_#
demos: build
	for f in demos/*.script; do $(MAKE) "$${f%.script}.gif"; done

#_# clean
#_#   Remove build and test artifacts
#_#
clean:
	rm -f tests/output
	rm -f demos/*.gif
	rm -f demos/*.cast

#_# tests
#_#   Run test suite and diff with expected results
#_#
tests: build
	rm -f tests/output
	tests/run > tests/output
	diff tests/output tests/expected

