#include "pipewith.sh"

# pipeline sep prog1 [sep prog2 ...]
pipeline() {
  pipewith '' "$@"
}

