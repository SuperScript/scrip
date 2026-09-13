# err_append_to path prog
#   Append error output from program to path
err_append_to() {
  local output="$1"
  shift
  mkdir -p "$(dirname "${output}")" || return $?
  "$@" 2>> "${output}"
}
