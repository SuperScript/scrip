#include "from.sh"
#include "safe.sh"
#_# do_from path cmd [args]
#_#   Read input for program from path
#_#
do_from() {
  local input="$1"
  shift
  safe from "${input}" "do_$@"
}
