#include "pipewith.sh"
#include "do_run.sh"

# pipeline sep prog1 [sep prog2 ...]
pipeline() {
  pipewith do_run "$@"
}

