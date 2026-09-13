# from path prog
#   Read input for program from path
from() {
  local input="$1"
  shift
  "$@" < "${input}"
}
