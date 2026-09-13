#include "err_to.sh"
#include "safe.sh"
#_# do_err_to path cmd [args]
#_#   Write error output from program to path
#_#
do_err_to() {
  local output="$1"
  shift
  safe err_to "${output}" "do_$@"
}
