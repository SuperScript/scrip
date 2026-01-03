#!/bin/sh

# init-script.sh - Initialize a new shell script with standard structure
#
# Usage: init-script.sh <script-name> [output-dir]
#
# Creates a new shell script with the standard template structure

shout() { printf '%s\n' "$0: $*" >&2; }
barf() { shout "fatal: $*"; exit 111; }
usage() { shout "usage: $*"; exit 100; }

test $# -ge 1 || usage "$0 script-name [output-dir]"

script_name="$1"
output_dir="${2:-.}"

# Validate script name
case "$script_name" in
  */*) barf "script name should not contain path separators" ;;
  *.sh) ;;
  *) script_name="${script_name}.sh" ;;
esac

output_path="${output_dir}/${script_name}"

# Check if file already exists
test -f "$output_path" && barf "file already exists: $output_path"

# Create output directory if needed
mkdir -p "$output_dir" || barf "failed to create directory: $output_dir"

# Create the script
cat > "$output_path" <<'EOF'
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
EOF

# Make executable
chmod +x "$output_path" || barf "failed to set executable: $output_path"

printf 'Created: %s\n' "$output_path"
