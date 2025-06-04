#include "compose.sh"
#_# do_ sep prog1 [sep prog2 ...]
#_#   Build and execute pipeline sep-separated programs
#_#
do_() {
  compose 'do_' "$@"
}
