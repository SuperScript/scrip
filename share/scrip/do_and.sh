#include "and_with.sh"
#include "do_.sh"
#_# and sep func [sep func ...]
#_#   Execute and-list of do_ functions
#_#
do_and() {
  and_with do_ "$@"
}
