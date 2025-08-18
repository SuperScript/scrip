include mk/help.mk

.SUFFIXES: .script .cast .gif

#_# build
#_#   Build executables from src/*.sh
#_#
build:
	SCRIP_PATH=./lib sh -c 'for f in src/*.sh; do \
	  n="$${f%.sh}"; n="bin/$${n##src/}"; \
	  bin/scrip code "$$f" > "$$n.new" && chmod a+x "$$n.new" && mv "$$n.new" "$$n"; \
	done'

#_# .script.cast
#_#   Capture an asciinema recording of the source script
#_#
.script.cast: build
	rm -f "$$(dirname "$<")/$$(basename "$<" .script).cast"
	bin/asciinema-script cast "$$(dirname "$<")/$$(basename "$<" .script).cast" < $<

#_# .cast.gif
#_#   Create a .gif file from the .cast recording
#_#
.cast.gif: build
	bin/asciinema-script gif $< "$$(dirname "$<")/$$(basename "$<" .cast).gif"

#_# clean
#_#   Remove build and test artifacts
#_#
clean:
	rm -f tests/output

#_# tests
#_#   Run test suite and diff with expected results
#_#
tests: build
	rm -f tests/output
	tests/run > tests/output
	diff tests/output tests/expected

