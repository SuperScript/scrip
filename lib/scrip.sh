#include "usage.sh"
#include "do_help.sh"

#_# docs file ...
#_#   Print help for each file argument
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

#_#   deps file...
#_#     Print the list of included file paths
#_#     Path is printed only the first time encountered
#_#     Paths are sorted by order of encounter
#_#

#_#   code file...
#_#     Print the code in files, resolving includes
#_#     Includes are inserted only the first time encountered
#_#
_mode() {
  awk=`{ which gawk >/dev/null && echo gawk; } \
    || { which nawk >/dev/null && echo nawk; } \
    || echo awk`

  exec $awk '
  function shout(msg) { print "scrip: " msg | "cat - 1>&2"; }
  function barf(msg) { shout("fatal: " msg); exit 111; }
  function findfile(fname,  path,dirs,i,fullpath) {
    # If fname contains a slash or starts with ./, use as-is
    if (fname ~ /[\/]/ || fname ~ /^\.\//) return fname

    # Get search path from environment
    path = ENVIRON["SCRIP_PATH"]

    # If no path set, use sibling lib/ directory
    if (!path) {
      path = "${0%/*}"
      path = "${path%/*}/lib"
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

do_deps() {
  _mode deps "$@"
}

do_code() {
  _mode code "$@"
}

#_# scrip code|deps|docs|help file...
#_#

if test $# -lt 1
then
  usage "$0 code|deps|help file..."
fi

"do_$@"
