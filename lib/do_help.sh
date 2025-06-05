#_# help
#_#   Print this helpful message
#_#
do_help() {
  sed -n 's/^#_#/ /p' "$0"
}

