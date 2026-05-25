# atomic_to path prog
#   Write output from program to path atomically
atomic_to() {
  local output="$1"
  shift
  mkdir -p "$(dirname "${output}")" || exit $?
  local temp
  temp="$(mktemp "${output}.XXXXXX")" || exit $?
  "$@" > "${temp}" && mv "${temp}" "${output}" || {
    local e=$?
    rm -f "${temp}"
    exit $e
  }
}

