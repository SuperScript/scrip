match() {
  echo "$2" | { grep -E -q -e "$1" || exit 100; }
}

