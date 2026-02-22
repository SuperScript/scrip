#_# set [options] cmd [args]
#_#   Apply set options, then execute cmd
#_#
do_set() {
  while test $# -gt 0
  do
    case "$1" in
      -o|+o) set "$1" "$2"; shift 2 ;;
      -*|+*) set "$1"; shift ;;
      *)     break ;;
    esac
  done
  "do_$@"
}
