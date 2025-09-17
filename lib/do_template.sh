#!/bin/sh

#### template functions

#include "shout.sh"
#include "barf.sh"
#include "safe.sh"
#include "catch.sh"
#include "usage.sh"
#include "have_args.sh"
#include "pipeline.sh"
#include "do_.sh"
#include "atomic_to.sh"
#include "atomic_to_mode.sh"
#include "do_help.sh"
#include "do_run.sh"
#include "do_xrun.sh"

#### program functions

#### parameters

sep='::'

#### main

if test $# -lt 1
then
  usage "$0 prog1 [${sep} prog2 ...]"
fi

pipewith do_ "${sep}" "$@"
