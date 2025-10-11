#include "ditto.sh"
shout() { ditto "$0: $*" >&2; }
