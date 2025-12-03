#_# do_to path cmd [args]
#_#   Write output from program to path atomically
#_#
do_to() {
  local output="$1"
  shift
  local temp="$(mktemp "${output}.XXXXXX")"
  "do_$@" > "${temp}" && mv "${temp}" "${output}" || {
    local e=$?
    rm -f "${temp}"
    exit $e
  }
}

