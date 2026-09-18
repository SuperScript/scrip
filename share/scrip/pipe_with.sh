pipe_cmd() {
  local wrap=${1:+'"$1"'}
  local sep="$2"
  shift 2

  local cmd=''
  local i=3
  local p="${wrap}"
  for a in "$@"
  do
    if test "$a" = "${sep}"
    then
      cmd="${cmd} |"
      p="${wrap}"
    else
      cmd="${cmd} ${p} \"\${$i}\""
      p=''
    fi
    i=$(($i + 1))
  done

  printf '%s\n' "${cmd}"
}

# pipe_with cmd sep args1 [sep args2 ...]
#   Empty cmd is no prefix.
pipe_with() {
  eval "$(pipe_cmd "$@")"
}
