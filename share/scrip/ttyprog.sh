# ttyprog prog [args]
#   Run prog with stdin/stdout on /dev/tty.
#   Pipeline data available at $TTY_INPUT.
#   Prog writes results to $TTY_OUTPUT.
ttyprog() {
  local tmpdir="$(mktemp -d "${TMPDIR:-/tmp}/ttyprog.XXXXXX")"
  cat > "${tmpdir}/input"
  export TTY_INPUT="${tmpdir}/input"
  export TTY_OUTPUT="${tmpdir}/output"
  local e=0
  "$@" < /dev/tty > /dev/tty || e=$?
  if test -f "${tmpdir}/output"
  then
    cat "${tmpdir}/output"
  fi
  rm -rf "${tmpdir}"
  return $e
}
