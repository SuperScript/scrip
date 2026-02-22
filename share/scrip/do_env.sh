#_# env [VAR=val ...] cmd [args]
#_#   Export variables, then execute cmd
#_#
do_env() {
  while test $# -gt 0
  do
    case "$1" in
      *=*) export "$1"; shift ;;
      *)   break ;;
    esac
  done
  "do_$@"
}
