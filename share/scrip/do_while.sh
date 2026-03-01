#_# while prog
#_#   For each stdin line, execute `prog "$line"`
#_#
do_while() {
  while read x
  do
    "do_$@" "$x"
  done
}


