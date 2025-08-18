#!/bin/sh

#include "usage.sh"
#include "do_help.sh"

delay='.10s'
font_size='18'

# typeout < lines
_typecat() {
  awk -F'\0' -v delay="${delay}" '{
    for (i=1;i<=length;i++) {
      c = substr($0,i,1)
      if (c == "\047") {
        print "sleep " delay "; printf \047%s\047 \"\047\""
      }
      else {
        print "sleep " delay "; printf \047%s\047 \047" c "\047"
      }
    }
    print "printf \047\\n\047"
  }' \
  | sh
}

# typelines line [...]
_typelines() {
  printf '%s\n' "$@" | _typecat
}

# run < commands
_run() {
  while read x rest
  do
    case "$x" in
    t|typelines)
      _typelines "${rest}"
      ;;
    s|sleep)
      sleep "${rest}"
      ;;
    esac
  done
  echo exit 0
}

#_# cast cast_file < commands
#_#   cast script as a cast file
#_#   scripts contain these commands:
#_#     s n (sleep n seconds)
#_#     t line (type line into asciinema)
#_#
do_cast() {
  _run | sh -c '
    asciinema rec --cols=80 --rows=24 "$1"
  ' asciinema "$@"
  exit 0
}

#_# gif cast_file gif_file
#_#   convert cast_file into gif_file with standard arguments
#_#
do_gif() {
  agg --font-size "${font_size}" --cols 80 --rows 24 --fps-cap 10 --theme solarized-dark "$@"
  exit 0
}

#### main

test $# -gt 0 || usage "$0 command [args] < [inputs]"

"do_$@"

