# atomic_to path prog
#   Write output from program to path atomically
atomic_to() {
  local output="$1"
  shift
  mkdir -p "$(dirname "${output}")" || return $?
  local temp
  temp="$(mktemp "${output}.XXXXXX")" || return $?
  "$@" > "${temp}" && mv "${temp}" "${output}" || {
    local e=$?
    rm -f "${temp}"
    return $e
  }
}

