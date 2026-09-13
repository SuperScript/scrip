# fd_from n path prog
#   Read input for program on fd n from path
fd_from() {
  local n="$1"
  local input="$2"
  shift 2
  case "${n}" in
    ''|*[!0-9]*) return 1 ;;
  esac
  eval '"$@" '"${n}"'< "${input}"'
}
