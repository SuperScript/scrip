#_# foreach cmd args
#_#   For each stdin line, execute `cmd $line args`
#_#
do_foreach() {
  local cmd="$1"
  shift
  while read x
  do
    "do_${cmd}" "$x" "$@"
  done
}


