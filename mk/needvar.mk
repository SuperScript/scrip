#_# needvar.X: Check whether $(X) is nonempty
#_#
_NEEDVAR_TYPE != list="$(MAKEFILE_LIST)"; if [ -n "$$list" ]; then for _f in $$list; do :; done; echo "$$(dirname "$$_f")/needvar.gnu.mk"; else echo needvar.bsd.mk; fi
include $(_NEEDVAR_TYPE)
