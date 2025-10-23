include mk/help.mk

needvars = target
include mk/needvar.mk

.SUFFIXES: .script .cast .gif

#_# bin/scrip
#_#   Build the scrip preprocessor from lib/scrip.sh
#_#
bin/scrip: src/scrip lib/scrip.sh lib/usage.sh lib/shout.sh lib/do_help.sh
	SCRIP_PATH=./lib /bin/sh -c '. lib/scrip.sh && do_code src/scrip' > bin/scrip.new && chmod a+x bin/scrip.new && mv bin/scrip.new bin/scrip

#_# build
#_#   Build executables from src/*.sh
#_#
build: bin/scrip needvar.target
	bin/scrip make "$(target)" > "build/Makefile.$(target).new" && mv "build/Makefile.$(target).new" "build/Makefile.$(target)"
	$(MAKE) -f "build/Makefile.$(target)"

all: src/*
	for f in src/*; do f="$${f#src/}" && test "$$f" = 'scrip' || $(MAKE) build target="$$f"; done

#_# .script.cast
#_#   Capture an asciinema recording of the source script
#_#
.script.cast: all
	rm -f "$@"
	bin/asciinema-script cast "$@" < $<

#_# .cast.gif
#_#   Create a .gif file from the .cast recording
#_#
.cast.gif: all
	bin/asciinema-script gif $< "$@"

#_# demos
#_#   Create a .gif file for each demos/*.script file
#_#
demos: all
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
tests: all
	rm -f tests/output
	tests/run > tests/output
	diff tests/output tests/expected

