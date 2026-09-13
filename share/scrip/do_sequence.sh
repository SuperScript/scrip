#include "sequence_with.sh"
#include "do_.sh"
#_# sequence sep func [sep func ...]
#_#   Execute sequence of do_ functions
#_#
do_sequence() {
  sequence_with do_ "$@"
}
