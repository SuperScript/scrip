# tmux_filter prog [args]
#   Run prog in a tmux split pane.
#   Pipeline data available at $TMUX_FILTER_INPUT.
#   Prog writes results to $TMUX_FILTER_OUTPUT.
tmux_filter() {
  test -n "${TMUX:-}" || barf "not running under tmux"
  local tmpdir
  tmpdir="$(mktemp -d "${TMPDIR:-/tmp}/tmux_filter.XXXXXX")"
  cat > "${tmpdir}/input"
  local channel="tmux_filter.$(basename "${tmpdir}")"
  tmux split-window -v -c "$(pwd)" sh -c '
    d="$1"; s="$2"; shift 2
    trap "tmux wait-for -S $s" EXIT
    TMUX_FILTER_INPUT="$d/input" TMUX_FILTER_OUTPUT="$d/output" "$@"
    printf %s $? > "$d/exitcode"
  ' _ "${tmpdir}" "${channel}" "$@"
  tmux wait-for "${channel}"
  local e=0
  if test -f "${tmpdir}/exitcode"
  then
    read e < "${tmpdir}/exitcode"
  fi
  if test -f "${tmpdir}/output"
  then
    cat "${tmpdir}/output"
  fi
  rm -rf "${tmpdir}"
  return "$e"
}

