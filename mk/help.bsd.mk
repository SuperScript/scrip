.if !defined(HELP_TARGET)
help:
	@for m in $(.MAKE.MAKEFILES); do \
          case "$$m" in (help.bsd.mk|*/help.bsd.mk|help.gnu.mk|*/help.gnu.mk|/usr/share/mk/*) continue;; esac; \
	  echo "$$m:" && \
	  sed -n 's/^#_#/ /p' "$$m"; \
	done

HELP_TARGET := 1
.endif

