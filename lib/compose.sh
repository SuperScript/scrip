# compose tail-prefix prefix sep prog1 [sep prog2 ...]
# compose() {
#   local tail_prefix=" $1"
#   local tail=
#   local head_prefix=" $2"
#   local head=
#   local sep="$3"
#   shift 3
#   local is_head=t
#   local a
#   local i=0
#   for a in "$@"
#   do
#     i=$(( 1 + $i ))
#     if test -n "${is_head}"
#     then
#       if test "$a" = "${sep}"
#       then
#         is_head=
#         continue
#       fi
#       head="${head}\"\${$i}\" "
#     else
#       tail="${tail}\"\${$i}\" "
#     fi
#   done
#   if test -n "${tail}"
#   then
#     eval "${head_prefix}${head}" | eval "${tail_prefix} ${tail}"
#   else
#     eval "${head_prefix}${head}"
#   fi
# }

# compose tail-prefix prefix sep prog1 [sep prog2 ...]
_compose() {
  local tail_prefix=" ${COMPOSE_TAIL_PREFIX:-}"
  local tail=
  local head_prefix=" ${COMPOSE_HEAD_PREFIX:-}"
  local head=
  local sep="${COMPOSE_SEP:-|}"
  # shift 3
  local is_head=t
  local a
  local i=0
  for a in "$@"
  do
    i=$(( 1 + $i ))
    if test -n "${is_head}"
    then
      if test "$a" = "${sep}"
      then
        is_head=
        continue
      fi
      head="${head}\"\${$i}\" "
    else
      tail="${tail}\"\${$i}\" "
    fi
  done
  if test -n "${tail}"
  then
    eval "${head_prefix}${head}" | eval "${tail_prefix} ${tail}"
  else
    eval "${head_prefix}${head}"
  fi
}

# compose head-prefix sep prog1 [sep prog2 ...]
compose() {
  local prefix="$1"
  local sep="$2"
  shift 2
  COMPOSE_TAIL_PREFIX='_compose ' \
  COMPOSE_HEAD_PREFIX="${prefix}" \
  COMPOSE_SEP="${sep}" \
  _compose "$@"
}
