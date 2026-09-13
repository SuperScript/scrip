# err_to_mode path mode prog
#   Write error output from program to path
#   Change mode after writing
err_to_mode() {
  local output="$1"
  local mode="$2"
  shift 2
  mkdir -p "$(dirname "${output}")" || return $?
  "$@" 2> "${output}" && chmod "${mode}" "${output}"
}
