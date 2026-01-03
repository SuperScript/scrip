#!/bin/sh

#### template functions

#include "shout.sh"
#include "barf.sh"
#include "usage.sh"
#include "do_help.sh"

#### program functions

#_# command1 args...
#_#   Description of command1
#_#
do_command1() {
  echo "TODO: implement command1"
}

#_# command2 args...
#_#   Description of command2
#_#
do_command2() {
  echo "TODO: implement command2"
}

#### parameters

# Add script parameters here

#### main

test $# -gt 0 || usage "$0 command [args]"

"do_$@"
