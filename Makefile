include mk/help.mk

#_# build
#_#   The default target
#_#
build:

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

