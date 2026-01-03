# Common Shell Scripting Patterns

## Complete Script Examples

### Simple Command Dispatcher

```sh
#!/bin/sh

#### template functions

#include "shout.sh"
#include "barf.sh"
#include "usage.sh"
#include "do_help.sh"

#### program functions

#_# build
#_#   Build the project
#_#
do_build() {
  test -f Makefile || barf "no Makefile found"
  make
}

#_# clean
#_#   Clean build artifacts
#_#
do_clean() {
  rm -rf build/
  rm -f *.o
}

#_# test
#_#   Run tests
#_#
do_test() {
  do_build
  ./run-tests
}

#### main

test $# -gt 0 || usage "$0 build|clean|test|help"

"do_$@"
```

### Pipeline Script

```sh
#!/bin/sh

#### template functions

#include "shout.sh"
#include "barf.sh"
#include "usage.sh"
#include "pipeline.sh"
#include "do_.sh"

#### program functions

#_# validate
#_#   Validate input data
#_#
do_validate() {
  grep -v '^#' | grep -v '^$'
}

#_# transform
#_#   Transform data
#_#
do_transform() {
  awk '{print toupper($0)}'
}

#_# format
#_#   Format output
#_#
do_format() {
  column -t
}

#### parameters

sep='::'

#### main

test $# -gt 0 || usage "$0 command1 [${sep} command2 ...]"

pipewith do_ "${sep}" "$@"
```

### File Processing Script

```sh
#!/bin/sh

#### template functions

#include "shout.sh"
#include "barf.sh"
#include "usage.sh"
#include "atomic_to.sh"

#### program functions

process_file() {
  local input="$1"
  local output="$2"

  test -f "$input" || barf "input file not found: $input"

  atomic_to "$output" sed 's/foo/bar/g' "$input"
}

#### main

test $# -eq 2 || usage "$0 input output"

process_file "$1" "$2"
```

## Error Handling Patterns

### Basic Error Detection

```sh
# Check command success
command || barf "command failed"

# Check file existence
test -f "$file" || barf "file not found: $file"

# Check directory existence
test -d "$dir" || barf "directory not found: $dir"

# Check if variable is set
test -n "$var" || barf "variable not set"
```

### Cleanup on Error

```sh
cleanup() {
  rm -f "$temp_file"
  rm -rf "$temp_dir"
}

trap cleanup EXIT

# Rest of script...
```

### Capturing and Checking Exit Codes

```sh
command
exit_code=$?
test $exit_code -eq 0 || barf "command failed with code $exit_code"

# Or more concisely:
command || barf "command failed"
```

## File Operations

### Atomic File Creation

```sh
#include "atomic_to.sh"

# Write content to file atomically
atomic_to "config.txt" printf '%s\n' "setting=value"

# Process and write atomically
atomic_to "output.json" jq '.foo = "bar"' input.json

# Pipe content atomically
echo "data" | atomic_to "output.txt" cat
```

### Safe File Deletion

```sh
# Only delete if exists
test -f "${file}" && rm "${file}"

# Delete with error checking
test -f "${file}" || barf "file not found: ${file}"
rm "${file}" || barf "failed to delete: ${file}"
```

### Reading Files Line by Line

```sh
while read -r line
do
  # Process each line
  printf '%s\n' "$line"
done < "$input_file"
```

### Creating Temporary Files

```sh
temp="$(mktemp)"
trap 'rm -f "${temp}"' EXIT

# Use temp file
echo "data" > "${temp}"
process "${temp}"
```

## Argument Processing

### Basic Argument Validation

```sh
# At least one argument
test $# -gt 0 || usage "$0 command [args]"

# Exactly N arguments
test $# -eq 2 || usage "$0 source dest"

# Between N and M arguments
test $# -ge 1 || usage "$0 file [files...]"
test $# -le 10 || barf "too many arguments"
```

### Processing Multiple Arguments

```sh
# Process all arguments
for arg in "$@"
do
  process "$arg"
done

# Shift through arguments
while test $# -gt 0
do
  case "$1" in
    -v) verbose=1 ;;
    -*) usage "$0 [-v] files..." ;;
    *) process "$1" ;;
  esac
  shift
done
```

### Optional Arguments with Defaults

```sh
input="${1:-input.txt}"
output="${2:-output.txt}"
```

## Text Processing

### Using sed

```sh
# Substitute text
sed 's/old/new/g' file.txt

# Delete lines
sed '/pattern/d' file.txt

# Extract lines
sed -n '/start/,/end/p' file.txt

# In-place edit (with atomic write)
atomic_to "${file}" sed 's/old/new/g' "${file}"
```

### Using awk

```sh
# Print specific columns
awk '{print $1, $3}' file.txt

# Filter rows
awk '$2 > 100' file.txt

# Sum column
awk '{sum += $1} END {print sum}' file.txt
```

### Using grep

```sh
# Find pattern
grep 'pattern' file.txt

# Inverse match
grep -v 'pattern' file.txt

# Count matches
grep -c 'pattern' file.txt

# Quiet mode (just exit code)
grep -q 'pattern' file.txt && echo "found"
```

## Control Flow

### Conditional Execution

```sh
# If-then-else
if test -f "$file"
then
  process "$file"
else
  barf "file not found: $file"
fi

# Compact form
test -f "$file" && process "$file" || barf "file not found"
```

### Case Statements

```sh
case "$command" in
  start)
    do_start
    ;;
  stop)
    do_stop
    ;;
  restart)
    do_stop
    do_start
    ;;
  *)
    usage "$0 start|stop|restart"
    ;;
esac
```

### Loops

```sh
# For loop over arguments
for file in "$@"
do
  process "$file"
done

# For loop over glob
for file in *.txt
do
  test -f "$file" && process "$file"
done

# While loop
count=0
while test $count -lt 10
do
  process $count
  count=$((count + 1))
done
```

## Function Patterns

### Functions with Local Variables

```sh
process_item() {
  local item="$1"
  local result="$2"

  # Process item
  local temp="$(transform "${item}")"

  # Write result
  printf '%s\n' "${temp}" > "${result}"
}
```

### Functions with Return Values via stdout

```sh
get_value() {
  local key="$1"
  grep "^${key}=" config.txt | cut -d= -f2
}

# Usage
value="$(get_value "setting")"
```

### Functions with Exit on Error

```sh
#include "safe.sh"

process() {
  safe command1
  safe command2
  safe command3
}
```

## Advanced Patterns

### Error Detection with catch

```sh
#include "catch.sh"

# catch regex command...
#   Exit with code 111 if stderr matches regex
catch 'ERROR' risky_command arg1 arg2
```

### Pipeline with Custom Separator

```sh
#include "pipewith.sh"

# Use :: as separator instead of |
pipewith do_run '::' cat file.txt '::' grep pattern '::' sort
```

### Creating Makefile Rules

```sh
# Generate Makefile dependencies
printf 'target: '
for dep in "$@"
do
  printf '%s ' "$dep"
done
printf '\n\t%s\n' "command to build target"
```

## Common Utilities

### Finding Executables

```sh
# Check if command exists
which command >/dev/null || barf "command not found"

# Find preferred version
awk="$({ which gawk >/dev/null && echo gawk; } \
  || { which nawk >/dev/null && echo nawk; } \
  || echo awk)"
```

### Date and Time

```sh
# Current timestamp
timestamp="$(date +%Y%m%d-%H%M%S)"

# ISO format
date -u +%Y-%m-%dT%H:%M:%SZ
```

### Working with Paths

```sh
# Get directory of script
script_dir="$(dirname "$0")"

# Get absolute path
abs_path="$(cd "$(dirname "${file}")" && pwd)/$(basename "${file}")"

# Create parent directory
mkdir -p "$(dirname "${output}")"
```
