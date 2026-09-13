# append_to_mode path mode prog
#   Append output from program to path
#   Change mode after appending
append_to_mode() {
  local output="$1"
  local mode="$2"
  shift 2
  mkdir -p "$(dirname "${output}")" || return $?
  "$@" >> "${output}" && chmod "${mode}" "${output}"
}
