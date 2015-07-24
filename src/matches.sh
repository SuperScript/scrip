matches() {
  matches_re="$1"
  shift
  while test 0 -lt $#
  do
    echo "$1" | { grep -E -q -e "$matches_re" || exit 100; }
    shift
  done
}
