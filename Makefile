PREFIX = /usr/local
BINARIES = scrip pipeline pipewith asciinema-script

needvars = target

.SUFFIXES: .script .cast .gif

#_# help
#_#   Display this helpful message
#_#
help:
	@seen=; for m in $(MAKEFILE_LIST) $(.MAKE.MAKEFILES); do \
	  case "$$m" in (/usr/share/mk/*) continue;; esac; \
	  case " $$seen " in (*" $$m "*) continue;; esac; \
	  echo "$$m:" && \
	  sed -n 's/^#_#/ /p' "$$m"; \
	  seen="$$seen $$m"; \
	done

#_# needvar.X
#_#   Check whether $(X) is nonempty
#_#   Add X to needvars to enable
#_#
_NEEDVAR_TARGETS != for v in $(needvars); do printf 'needvar.%s ' "$$v"; done
_NEEDVAR_LOOKUP != for v in $(needvars); do printf '%s) val='"'"'$$(%s)'"'"';; ' "$$v" "$$v"; done

.PHONY: $(_NEEDVAR_TARGETS)
$(_NEEDVAR_TARGETS):
	@v=$@; v=$${v#needvar.}; val=; \
	  case "$$v" in $(_NEEDVAR_LOOKUP) esac; \
	  test -n "$$val" || { echo "variable not defined: $$v" >&2; exit 1; }

#_# bin/scrip
#_#   Build the scrip preprocessor from share/scrip/scrip.sh
#_#
bin/scrip: src/scrip share/scrip/scrip.sh share/scrip/usage.sh share/scrip/shout.sh share/scrip/do_help.sh
	@/bin/sh -c '. share/scrip/scrip.sh && do_code src/scrip' bin/scrip > bin/scrip.new && chmod a+x bin/scrip.new && mv bin/scrip.new bin/scrip

# #_# all
# #_#   Build executables for all sources in src/*
# #_#

all: bin/scrip src/*
	@for f in src/*; do f="$${f#src/}" && test "$$f" = 'scrip' || bin/scrip prog "bin/$$f" "src/$$f"; done

#_# .script.cast
#_#   Capture an asciinema recording of the source script
#_#
.script.cast:
	@$(MAKE) all
	@rm -f "$@"
	@bin/asciinema-script cast "$@" < $<

#_# .cast.gif
#_#   Create a .gif file from the .cast recording
#_#
.cast.gif:
	@$(MAKE) all
	@bin/asciinema-script gif $< "$@"

#_# demos
#_#   Create a .gif file for each demos/*.script file
#_#
demos: all
	@for f in demos/*.script; do $(MAKE) "$${f%.script}.gif"; done

#_# clean
#_#   Remove build and test artifacts
#_#
clean:
	@rm -f tests/output
	@rm -fr tests/basedir
	@rm -f demos/*.gif
	@rm -f demos/*.cast

#_# tests
#_#   Run test suite and diff with expected results
#_#
tests: all
	@rm -f tests/output
	@tests/run > tests/output
	@diff tests/output tests/expected

#_# install
#_#   Install executables and libraries to PREFIX (default: /usr/local)
#_#
install: all
	@install -d "$(PREFIX)/bin"
	@install -d "$(PREFIX)/share/scrip"
	@for bin in $(BINARIES); do install -m 755 "bin/$${bin}" "$(PREFIX)/bin/"; done
	@install -m 644 share/scrip/* "$(PREFIX)/share/scrip/"

#_# uninstall
#_#   Remove installed files from PREFIX
#_#
uninstall:
	@for bin in $(BINARIES); do rm -f "$(PREFIX)/bin/$${bin}"; done
	@rm -rf "$(PREFIX)/share/scrip"

