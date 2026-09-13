#include "fd_to.sh"
#include "safe.sh"
#_# do_fd_to n path cmd [args]
#_#   Write output from program on fd n to path
#_#
do_fd_to() {
  local n="$1"
  local output="$2"
  shift 2
  safe fd_to "${n}" "${output}" "do_$@"
}
