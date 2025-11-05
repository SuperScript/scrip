ifndef HELP_TARGET
help:
	@for m in $(MAKEFILE_LIST); do \
          case "$$m" in (*.bsd.mk|*.gnu.mk|*\ $$m\ *) continue;; esac; \
	  echo "$$m:" && \
	  sed -n 's/^#_#/ /p' "$$m"; \
	  makefile_list="$${makefile_list} $$m"; \
	done

HELP_TARGET := 1
endif

