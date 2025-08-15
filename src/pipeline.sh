#!/bin/sh
#include "pipeline.sh"
#include "usage.sh"

test $# -gt 1 || usage "$0 sep prog [sep prog ...]"
pipeline '' "$@"

