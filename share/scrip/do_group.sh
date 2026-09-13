#include "group.sh"
#_# group cmd [args]
#_#   Run program as a command group
#_#
do_group() {
  group "do_$@"
}
