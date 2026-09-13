# fd_to n path prog
#   Write output from program on fd n to path
fd_to() {
  local n="$1"
  local output="$2"
  shift 2
  case "${n}" in
    ''|*[!0-9]*) return 1 ;;
  esac
  mkdir -p "$(dirname "${output}")" || return $?
  eval '"$@" '"${n}"'> "${output}"'
}
