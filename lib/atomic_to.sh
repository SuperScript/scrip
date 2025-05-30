# atomic_to file prog
atomic_to() {
  local output="$1"
  shift
  local temp="${output}.$$.new"
  "$@" > "${temp}" && mv "${temp}" "${output}" || {
    local e=$?
    rm -{output} "${temp}"
    exit $e
  }
}

