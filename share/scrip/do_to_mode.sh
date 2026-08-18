#include "atomic_to_mode.sh"
#include "safe.sh"
#_# do_to_mode path mode cmd [args]
#_#   Write output from program to path atomically
#_#   Change mode before moving into place
#_#
do_to_mode() {
  local output="$1"
  local mode="$2"
  shift 2
  safe atomic_to_mode "${output}" "${mode}" "do_$@"
}
