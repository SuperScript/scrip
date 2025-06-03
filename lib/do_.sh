#include "compose.sh"
# do_ sep prog1 [sep prog2 ...]
do_() {
  compose 'do_' "$@"
}
