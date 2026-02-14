#_# help
#_#   Display this helpful message
#_#
_HELP_TYPE != list="$(MAKEFILE_LIST)"; if [ -n "$$list" ]; then for _f in $$list; do :; done; echo "$$(dirname "$$_f")/help.gnu.mk"; else echo help.bsd.mk; fi
include $(_HELP_TYPE)
