#_# help
#_#   Print this helpful message
#_#
do_help() {
  sed '/^#_#/!d;s/^#_#/ /;s/^ *$//' "$0"
}

