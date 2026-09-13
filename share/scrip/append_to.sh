# append_to path prog
#   Append output from program to path
append_to() {
  local output="$1"
  shift
  mkdir -p "$(dirname "${output}")" || return $?
  "$@" >> "${output}"
}
