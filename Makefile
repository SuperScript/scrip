include mk/help.mk

#_# build
#_#   The default target
#_#
build:
	SCRIP_PATH=./lib sh -c 'for f in src/*.sh; do \
	  echo "handle $$f" >&2; \
	  n="$${f%.sh}"; n="bin/$${n##src/}"; \
	  bin/scrip code "$$f" > "$$n.new" && chmod a+x "$$n.new" && mv "$$n.new" "$$n"; \
	done'

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

