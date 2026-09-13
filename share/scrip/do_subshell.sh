#include "subshell.sh"
#_# subshell cmd [args]
#_#   Run program in a subshell
#_#
do_subshell() {
  subshell "do_$@"
}
