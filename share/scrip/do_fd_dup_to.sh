#include "fd_dup_to.sh"
#include "safe.sh"
#_# do_fd_dup_to n m cmd [args]
#_#   Duplicate fd m onto fd n for the program
#_#   m may be - to close n
#_#
do_fd_dup_to() {
  local n="$1"
  local m="$2"
  shift 2
  safe fd_dup_to "${n}" "${m}" "do_$@"
}
