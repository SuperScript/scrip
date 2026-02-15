#_# help
#_#   Display this helpful message
#_#
help:
	@seen=; for m in $(MAKEFILE_LIST) $(.MAKE.MAKEFILES); do \
	  case "$$m" in (*.bsd.mk|*.gnu.mk|/usr/share/mk/*) continue;; esac; \
	  case " $$seen " in (*" $$m "*) continue;; esac; \
	  echo "$$m:" && \
	  sed -n 's/^#_#/ /p' "$$m"; \
	  seen="$$seen $$m"; \
	done
