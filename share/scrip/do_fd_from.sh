#include "fd_from.sh"
#include "safe.sh"
#_# do_fd_from n path cmd [args]
#_#   Read input for program on fd n from path
#_#
do_fd_from() {
  local n="$1"
  local input="$2"
  shift 2
  safe fd_from "${n}" "${input}" "do_$@"
}
