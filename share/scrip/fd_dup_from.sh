# fd_dup_from n m prog
#   Duplicate fd m onto fd n for the program
#   m may be - to close n
fd_dup_from() {
  local n="$1"
  local m="$2"
  shift 2
  case "${n}" in
    ''|*[!0-9]*) return 1 ;;
  esac
  case "${m}" in
    -) ;;
    ''|*[!0-9]*) return 1 ;;
  esac
  eval '"$@" '"${n}"'<&'"${m}"
}
