# Shell Scripting Style Guide

## UNIX Philosophy

Follow the UNIX philosophy strictly:
- **Silent success**: Scripts produce no output when successful
- **Errors to stderr**: All error messages go to stderr using `shout()` or `barf()`
- **Exit codes**: Use consistent exit codes (0=success, 100=usage error, 111=fatal error)

## Standard Script Structure

Every script follows this exact structure:

```sh
#!/bin/sh

#### template functions

#include "shout.sh"
#include "barf.sh"
#include "usage.sh"
#include "do_help.sh"
# ... other includes

#### program functions

# Implementation functions go here

#### parameters

# Script parameters/configuration go here

#### main

# Main execution logic goes here
```

### Section Breakdown

1. **Shebang**: Always `#!/bin/sh` (POSIX shell, not bash)
2. **Template functions**: Standard library includes using `#include` directives
3. **Program functions**: Script-specific implementation
4. **Parameters**: Configuration variables
5. **Main**: Entry point and argument handling

## Formatting and Indentation

**Indentation**: Use two spaces for indentation. Never use tabs.

```sh
# Correct - two spaces
do_example() {
  if test -f "$file"; then
    process "$file"
  fi
}

# Wrong - four spaces or tabs
do_example() {
    if test -f "$file"; then
        process "$file"
    fi
}
```

**Rationale**: Two-space indentation is compact while remaining readable, suitable for shell scripts which often have deep nesting in conditionals and loops.

## Standard Error Functions

### shout()
Print informational or error messages to stderr:
```sh
shout() { printf '%s\n' "$0: $*" >&2; }
```
Usage: `shout "informational message"`

### barf()
Print fatal error and exit with code 111:
```sh
#include "shout.sh"
barf() { shout "fatal: $*"; exit 111; }
```
Usage: `barf "something went wrong"`

### usage()
Print usage message and exit with code 100:
```sh
#include "shout.sh"
usage() { shout "usage: $*"; exit 100; }
```
Usage: `usage "$0 command [args]"`

## Variable Quoting

**CRITICAL**: Always quote variables rigorously to handle spaces and special characters.

**Multi-character variable names must use braces**: `"${variable}"` not `"$variable"`

```sh
# Correct - always quote, braces for multi-character names
local filename="$1"
test -f "${filename}"
rm "${filename}"
"${command}" "${arg1}" "${arg2}"

# Correct - single-digit positional parameters don't need braces
shift_count="$1"
process "$2" "$3"

# Wrong - unquoted variables
local filename=$1
test -f ${filename}
rm ${filename}

# Wrong - multi-character without braces
test -f "$filename"
"$command" "$arg1"
```

**Special cases (safe unquoted):**
- `$#` - number of parameters
- `$?` - exit code
- `$$` - process ID
- `$!` - last background PID

**Special expansions (always quote):**
- `"$@"` - all positional parameters as separate quoted words
- `"$*"` - all positional parameters as single word

**Exception for intentional unquoted usage:**

Unquoted variables are permitted ONLY when:
1. Word splitting or globbing is explicitly intended
2. A comment marks it as intentional

```sh
# Allowed - intentional word splitting with comment
for file in ${pattern}  # intentional: word splitting needed
do
  test -f "${file}" && process "${file}"
done

# Allowed - intentional globbing with comment
rm -f ${temp_files}  # intentional: glob expansion

# Not allowed - no comment explaining intent
for file in ${pattern}
do
  process "${file}"
done
```

## Subcommand Pattern

Use `do_*` functions for subcommand dispatch:

```sh
#_# help
#_#   Print this helpful message
#_#
do_help() {
  sed -n 's/^#_#/ /p' "$0"
}

#_# build
#_#   Build the project
#_#
do_build() {
  # implementation
}

#### main
test $# -gt 0 || usage "$0 command [args]"
"do_$@"
```

This pattern:
- Dispatches to `do_<command>` function
- Allows easy addition of new commands
- Integrates with `do_help()` for documentation

## Self-Documenting Help

Use `#_#` prefix for help text that's extracted by `do_help()`:

```sh
#_# command arg1 arg2
#_#   Description of what this command does
#_#   Can span multiple lines
#_#
do_command() {
  # implementation
}
```

Extract with:
```sh
do_help() {
  sed -n 's/^#_#/ /p' "$0"
}
```

## Atomic File Operations

Always use atomic writes for file operations to prevent corruption:

```sh
#include "atomic_to.sh"

# atomic_to path prog
#   Write output from program to path atomically
atomic_to() {
  local output="$1"
  shift
  local temp="$(mktemp "${output}.XXXXXX")"
  "$@" > "${temp}" && mv "${temp}" "${output}" || {
    local e=$?
    rm -f "${temp}"
    exit $e
  }
}
```

Usage:
```sh
atomic_to "output.txt" cat input.txt
atomic_to "config.json" jq '.' raw.json
```

Pattern: Create temp file → Write to temp → Move to final (atomic operation)

## Preferred Tools and Commands

Use these tools consistently:

- **`test` or `[ ]`**: Not `[[ ]]` (POSIX compliance)
- **`printf`**: Not `echo` (more predictable with special characters)
- **`local`**: For function-scoped variables
- **`mktemp`**: For temporary files
- **`sed`, `awk`**: For text processing

## Common Patterns

### Argument Validation

```sh
# Require at least one argument
test $# -gt 0 || usage "$0 command [args]"

# Require exactly N arguments
test $# -eq 2 || usage "$0 source dest"

# Check if file exists
test -f "$filename" || barf "file not found: $filename"
```

### Safe Function Execution

```sh
#include "safe.sh"

# safe command...
#   Exit if command fails
safe() {
  "$@" || exit $?
}
```

### Pipeline Construction

```sh
#include "pipeline.sh"

# pipeline sep prog1 [sep prog2 ...]
pipeline() {
  pipewith do_run "$@"
}

# Usage:
pipeline '::' cat file.txt '::' grep pattern '::' sort
```

## Include System

Scripts use `#include` directives for code reuse:

```sh
#include "shout.sh"   # Includes share/scrip/shout.sh
#include "barf.sh"    # Includes share/scrip/barf.sh
```

These are processed by the `scrip` build tool, not by the shell itself.

## Exit Codes

Use consistent exit codes:
- **0**: Success
- **100**: Usage error (wrong arguments)
- **111**: Fatal error (runtime failure)

## Comments

- Use `####` for major section headers
- Use `#` for inline comments explaining non-obvious logic
- Use `#_#` for self-documenting help text
- Don't comment obvious code - the code should be self-explanatory
