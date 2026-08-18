#include "atomic_to.sh"
#include "safe.sh"
#_# do_to path cmd [args]
#_#   Write output from program to path atomically
#_#
do_to() {
  local output="$1"
  shift
  safe atomic_to "${output}" "do_$@"
}
