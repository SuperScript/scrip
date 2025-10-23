#include "usage.sh"
# have_args n [args...]
#   Return 0 if args has at least n entries, else 1
have_args() {
  test $# -ge 1 || usage "have_args count [args...]"
  test "$1" -lt $#
  return $?
}

