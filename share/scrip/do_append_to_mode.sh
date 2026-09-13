#include "append_to_mode.sh"
#include "safe.sh"
#_# do_append_to_mode path mode cmd [args]
#_#   Append output from program to path
#_#   Change mode after appending
#_#
do_append_to_mode() {
  local output="$1"
  local mode="$2"
  shift 2
  safe append_to_mode "${output}" "${mode}" "do_$@"
}
