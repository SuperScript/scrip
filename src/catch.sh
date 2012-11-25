catch() {
  wrap_error_re="$1"
  shift
  { "$@" 2>&1 1>&9 | awk '
      BEGIN { rcode = 0 }
      !rcode && 1 == match($0,errstring) { rcode = 111 }
      { print $0 }
      END { exit rcode }
    ' errstring="$wrap_error_re" >&2
  } 9>&1
}
