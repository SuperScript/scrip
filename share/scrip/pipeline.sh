#include "pipe_with.sh"

# pipeline sep prog1 [sep prog2 ...]
pipeline() {
  pipe_with '' "$@"
}

