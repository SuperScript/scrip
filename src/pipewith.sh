#!/bin/sh
#include "pipewith.sh"
#include "usage.sh"

#_# pipewith cmd sep args1 [sep args2 ...]
#_#
test $# -gt 1 || usage "$0 cmd sep args1 [sep args2 ...]"
pipewith "$@"

