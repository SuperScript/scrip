#include "usage.sh"
#include "do_help.sh"
#include "atomic_to_mode.sh"

#_# docs [file ...]
#_#   Print help for each file argument
#_#   Run on $0 if no files given
#_#
do_docs() {
  if test $# -gt 0
  then
    for f in "$@"
    do
      printf '%s\n\n' "$f"
      sed -n 's/^#_#/ /p' "$f"
    done
  else
    printf '%s\n\n' "$0"
    sed -n 's/^#_#/ /p' "$0"
  fi
}

# _mode code|deps
#   code: render #includes recursively and write code to stdout
#   deps: print list of dependencies, one per line
_mode() {
  awk="$({ which gawk >/dev/null && echo gawk; } \
    || { which nawk >/dev/null && echo nawk; } \
    || echo awk)"

  "${awk}" -v default_path="$(dirname "$(dirname "$0")")/share/scrip" '
  function shout(msg) { print "scrip: " msg | "cat - 1>&2"; }
  function barf(msg) { shout("fatal: " msg); exit 111; }
  function findfile(fname,  path,dirs,i,fullpath) {
    # If fname contains a slash or starts with ./, use as-is
    if (fname ~ /[\/]/ || fname ~ /^\.\//) return fname

    # Get search path from environment
    path = ENVIRON["SCRIP_PATH"]

    # If no path set, use $0-relative share/scrip
    if (!path) {
      path = default_path
    }

    # Split path and search each directory
    split(path, dirs, ":")
    for (i in dirs) {
      if (dirs[i] == "") continue
      fullpath = dirs[i] "/" fname
      if ((getline < fullpath) >= 0) {
        close(fullpath)
        return fullpath
      }
    }

    # Fall back to original name
    return fname
  }
  function dofile(fname,  i,x,a,realfname) {
    # Skip if file was seen already
    if (1 == included[fname]) return

    # Find the actual file path
    realfname = findfile(fname)

    # Print name for deps mode
    if (deps) print realfname
    included[fname] = 1

    # Nest into dependency
    i = 0
    while (1) {
      r = getline x <realfname
      if (0 > r) barf("cannot open file: " realfname)
      if (0 == r) break
      line[i++,fname] = x;
    }
    close(realfname)
    lim[fname] = i

    # Process nested includes
    pos[fname] = 0
    while (pos[fname] < lim[fname]) {
      x = line[pos[fname]++,fname]
      if (x ~ /^#include[ \t]*"[^"]*"/) {
        split(x,a,"\"")
        dofile(a[2])
      }
      else {
        # Print line if code mode
        if (!deps) print x
      }
    }
  }

  BEGIN {
    mode = ARGV[1]
    ARGV[1] = ""
    mode ~ /^(deps|code)$/  || barf("unrecognized mode: " mode)
    deps = ("deps" == mode ? 1 : 0)
    for (i = 2;i < ARGC;++i) {
      dofile(ARGV[i]);
    }
    exit 0
  }
  { barf("this should never happen") }
  ' "$@"
}

#_# deps file...
#_#   Print the list of included file paths
#_#   Path is printed only the first time encountered
#_#   Paths are sorted by order of encounter
#_#
do_deps() {
  test $# -ge 1 || usage 'code [file...]'
  _mode deps "$@"
}

#_# code file...
#_#   Print the code in files, resolving includes
#_#   Includes are inserted only the first time encountered
#_#
do_code() {
  test $# -ge 1 || usage 'code [file...]'
  _mode code "$@"
}

#_# prog script file...
#_#   Render the files, resolving includes output to script
#_#   Write script with mode 0755
#_#
do_prog() {
  test $# -ge 2 || usage 'prog script [file...]'
  local script="$1"
  shift
  atomic_to_mode "${script}" 0755 _mode code "$@"
}

#_# borrow destdir file...
#_#   Copy all included dependencies to destdir
#_#
do_borrow() {
  test $# -ge 1 || usage 'borrow destdir [file...]'
  local dest="$1"
  shift
  mkdir -p "${dest}"
  _mode deps "$@" | while read -r f
  do
    test -f "$f" && cp "$f" "${dest}/"
  done
}

#_# make target...
#_#   Print Makefile rule for building each bin/target from share/scrip/target
#_#   Lists all dependencies and uses atomic write pattern
#_#
do_make() {
  for name in "$@"
  do
    target="bin/${name}"
    src="src/${name}"

    # Emit target and dependencies on one line
    printf '%s: bin/scrip' "${target}"
    # SCRIP_PATH=share/scrip _mode deps "${src}" | while read -r dep
    _mode deps "${src}" | while read -r dep
    do
      printf ' %s' "${dep}"
    done
    printf '\n'

    # Emit build command with tab prefix and atomic write pattern
    printf '\tbin/scrip prog %s %s\n' "${target}" "${src}"
    printf '\n'
  done
}

