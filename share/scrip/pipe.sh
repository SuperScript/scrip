#include "pipewith.sh"
#include "do_.sh"

# pipe sep func1 [sep func2 ...]
pipe() {
  pipewith do_ "$@"
}
