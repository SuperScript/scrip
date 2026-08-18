# atomic_to_mode path mode prog
#   Write output from program to path atomically
#   Change mode before moving into place
atomic_to_mode() {
  local output="$1"
  local mode="$2"
  shift 2
  mkdir -p "$(dirname "${output}")" || return $?
  local temp
  temp="$(mktemp "${output}.XXXXXX")" || return $?
  "$@" > "${temp}" && chmod "${mode}" "${temp}" && mv "${temp}" "${output}" || {
    local e=$?
    rm -f "${temp}"
    return $e
  }
}

