#include "safe.sh"
#include "save_to.sh"

usage="usage: save-to [ -h -- ] file prog"
usage() { shout "$usage"; exit 100; }

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

test 2 -le $# || usage

safe save_to "$@"

