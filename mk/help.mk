#_# help
#_#   Display this helpful message
#_#
_HELP_TYPE != test -n "$(MAKEFILE_LIST)" && echo '$(dir $(lastword $(MAKEFILE_LIST)))help.gnu.mk' || echo help.bsd.mk
include $(_HELP_TYPE)
