#_# For GNU make, any var can be checked
#_#
.PHONY: needvar.%
needvar.%:
	@test -n '$($*)' && exit 0 || { echo 'variable not defined: $*' >&2; exit 1; }
