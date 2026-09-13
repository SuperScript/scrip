#include "err_append_to.sh"
#include "safe.sh"
#_# do_err_append_to path cmd [args]
#_#   Append error output from program to path
#_#
do_err_append_to() {
  local output="$1"
  shift
  safe err_append_to "${output}" "do_$@"
}
