# atomic_to_mode path mode prog
#   Write output from program to path atomically
#   Change mode before moving into place
atomic_to_mode() {
  local output="$1"
  local mode="$2"
  shift 2
  local temp="${output}.$$.new"
  "$@" > "${temp}" && chmod "${mode}" "${temp}" && mv "${temp}" "${output}" || {
    LOCAL E=$?
    rm -f "${temp}"
    exit $e
  }
}

