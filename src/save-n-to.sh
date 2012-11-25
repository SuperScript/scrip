#include "safe.sh"
#include "save_to.sh"
#include "catch.sh"

usage="usage: save-n-to [ -h -- ] count file prog"
usage() { shout "$usage"; exit 100; }

cleanup() {
  cleanup_count="$1"
  cleanup_prefix="$2"
  safe ls -r "$cleanup_prefix"* \
  | safe tail "+2" \
  | safe tail "+$cleanup_count" \
  | while read cleanup_f
    do
      safe rm -f "$cleanup_f"
    done
}

#### main

while test 0 -lt $#
do
  case "$1" in
    -h)
      echo "$usage"
      exit 0
      ;;
    --)
      shift
      break
      ;;
    -*)
      usage
      ;;
    *)
      break
      ;;
  esac
done

test 3 -le $# || usage

suffix="`date '+%Y%m%d%H%M%S'`.$$.`hostname`"
count="$1"
file="$2"
shift; shift
safe save_to "$file.$suffix" "$@"
safe catch "$0: fatal: " cleanup "$count" "$file"
exit 0

