pipewith_cmd() {
  local sep="$2"
  shift 2

  local cmd=''
  local i=3
  local p='"$1"'
  for a in "$@"
  do
    if test "$a" = "${sep}"
    then
      cmd="${cmd} |"
      p='"$1"'
    else
      cmd="${cmd} ${p} \"\${$i}\""
      p=''
    fi
    i=$(($i + 1))
  done

  printf '%s\n' "${cmd}"
}

# pipewith cmd sep args1 [sep args2 ...]
pipewith() {
  eval "$(pipewith_cmd "$@")"
}

