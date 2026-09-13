#include "err_to_mode.sh"
#include "safe.sh"
#_# do_err_to_mode path mode cmd [args]
#_#   Write error output from program to path
#_#   Change mode after writing
#_#
do_err_to_mode() {
  local output="$1"
  local mode="$2"
  shift 2
  safe err_to_mode "${output}" "${mode}" "do_$@"
}
