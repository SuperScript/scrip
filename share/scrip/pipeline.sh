#include "pipe_with.sh"
#include "do_run.sh"

# pipeline sep prog1 [sep prog2 ...]
pipeline() {
  pipe_with do_run "$@"
}

