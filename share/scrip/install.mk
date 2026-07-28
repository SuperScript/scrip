#_# install
#_#   Install executables and libraries to PREFIX (default: /usr/local)
#_#
PREFIX ?= /usr/local

.PHONY: install
install:
	@install -d "$(PREFIX)/bin"
	@install -m 755 bin/* "$(PREFIX)/bin/"
	@find share -type d | while read -r d; do install -d "$(PREFIX)/$$d"; done
	@find share -type f | while read -r f; do install -m 644 "$$f" "$(PREFIX)/$$f"; done

# To install another tree, add it to the find lists here and in uninstall:
#	@find share etc -type d | while read -r d; do install -d "$(PREFIX)/$$d"; done
#	@find share etc -type f | while read -r f; do install -m 644 "$$f" "$(PREFIX)/$$f"; done

#_# uninstall
#_#   Remove installed files from PREFIX, leaving directories in place
#_#
.PHONY: uninstall
uninstall:
	@find bin share -type f | while read -r f; do rm -f "$(PREFIX)/$$f"; done

#	@find bin share etc -type f | while read -r f; do rm -f "$(PREFIX)/$$f"; done
