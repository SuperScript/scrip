#include "or_with.sh"
#include "do_.sh"
#_# or sep func [sep func ...]
#_#   Execute or-list of do_ functions
#_#
do_or() {
  or_with do_ "$@"
}
