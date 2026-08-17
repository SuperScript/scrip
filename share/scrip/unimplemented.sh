#include "usage.sh"
#include "barf.sh"
# unimplemented name [args...]
#   Barf, naming a command that has its help and none of its behaviour
unimplemented() {
  test $# -ge 1 || usage "unimplemented name [args...]"
  barf "not implemented: $*"
}
