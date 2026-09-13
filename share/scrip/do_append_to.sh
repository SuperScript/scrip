#include "append_to.sh"
#include "safe.sh"
#_# do_append_to path cmd [args]
#_#   Append output from program to path
#_#
do_append_to() {
  local output="$1"
  shift
  safe append_to "${output}" "do_$@"
}
