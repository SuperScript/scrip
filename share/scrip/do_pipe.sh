#include "pipe_with.sh"
#include "do_.sh"
#_# pipe sep func [sep func ...]
#_#   Execute pipeline of do_ functions
#_#
do_pipe() {
  pipe_with do_ "$@"
}
