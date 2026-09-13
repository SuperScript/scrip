#include "background.sh"
#_# background cmd [args]
#_#   Run program in the background
#_#
do_background() {
  background "do_$@"
}
