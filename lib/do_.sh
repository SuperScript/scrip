#include "compose.sh"
# do_ sep prog1 [sep prog2 ...]
#   Build and execute pipeline sep-separated programs
#
do_() {
  compose 'do_' "$@"
}
