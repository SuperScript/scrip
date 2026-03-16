#include "atomic_to.sh"
#_# do_to path cmd [args]
#_#   Write output from program to path atomically
#_#
do_to() {
  local output="$1"
  shift
  atomic_to "${output}" "do_$@"
}
