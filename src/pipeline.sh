#!/bin/sh
#include "pipeline.sh"
#include "usage.sh"

#_# pipeline sep prog [sep prog ...]
#_#
test $# -gt 1 || usage "$0 sep prog [sep prog ...]"
pipeline '' "$@"

