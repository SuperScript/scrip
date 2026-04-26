#include "ttyprog.sh"
#_# ttyprog func [args]
#_#   Run do_func with stdin/stdout on /dev/tty
#_#
do_ttyprog() {
  ttyprog "do_$@"
}
