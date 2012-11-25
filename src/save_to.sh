save_to() {
  save_to_file="$1"
  save_to_temp="$1.$$.tmp"
  shift

  "$@" > "$save_to_temp" \
    && mv "$save_to_temp" "$save_to_file" \
    && return 0
  rm -f "$save_to_temp"
  return 111
}
