# err_to path prog
#   Write error output from program to path
err_to() {
  local output="$1"
  shift
  mkdir -p "$(dirname "${output}")" || return $?
  "$@" 2> "${output}"
}
