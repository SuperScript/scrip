---
name: Shell Programming
description: POSIX shell programming conventions, quoting rules, and error handling patterns for the scrip project
when_to_use: when writing or modifying shell script library modules or programs
version: 1.0.0
languages: sh
---

# Shell Programming for scrip

## Overview

All shell code in scrip follows strict POSIX Bourne shell syntax plus `local` keyword. Every variable expansion must be quoted. The project uses a consistent error handling vocabulary (shout/barf/usage/safe/catch) and modular composition via #include.

**Core principle:** Quote everything, fail loudly, compose from lib/ modules.

## When NOT to Use

When asked explicitly to create a Bash script.

## The Iron Laws

```
1. POSIX sh only (plus `local`) - no bash/zsh/ksh extensions
2. Quote ALL variable expansions, with curly braces around multiletter variable names - "${var}" "${output}" (name does not include "$")
3. Use project error handling - shout/barf/usage/safe/catch
4. Document with #_# for help extraction
5. Test with output diff against tests/expected
```

## Quoting Rules

### Always Quote

**All variable expansions must be quoted, with curly braces around multi-character variable names:**

```sh
# ✅ CORRECT
"${var}"
"$@"
"${output}"
"${temp}"
"blahblahblah: $*"
printf '%s\n' "${message}"
"${12}"
for f in "$@"

# ❌ WRONG
"$var"
$@
${output}
printf '%s\n' $message
for f in $@
```

### Even in Tests

```sh
# ✅ CORRECT
test "$a" = "${sep}"
test $# -gt 0
if test -f "$f"
test "$1" -lt $#

# ❌ WRONG
test $a = ${sep}
if test -f $f
```

**Exception:** Numeric comparisons and `$#` don't need quotes:
```sh
test $# -gt 1    # OK - $# is always numeric
test "${count}" -eq 5  # GOOD - quote variables
```

### $@ vs $*

- **`"$@"`** - Each argument as separate word. Use for executing commands:
  ```sh
  safe() { "$@" || barf "cannot $*"; }
  #        ^^^^ execute command

- "$*" - All arguments joined with spaces. Use for messages:
barf() { shout "fatal: $*"; exit 111; }
#                      ^^^^ join for message

### Arithmetic Expansion

Arithmetic expressions don't need quotes (they can't contain spaces):

```sh
i=$(($i + 1))          # No quotes needed
count=$((${count} + 1))  # POSIX compliant

The counter variable must be initialized to a numeric value before use in an arithmetic expression.

### Function Arguments

```sh
# ✅ CORRECT - quote "$@"
do_run() {
  "$@"
}

safe() { "$@" || barf "cannot $*"; }

# ✅ CORRECT - quote individual args
atomic_to() {
  local output="$1"
  shift
  "$@" > "${output}"
}
```

### Command Substitution

```sh
# ✅ CORRECT - quote the substitution
local temp="$(mktemp "${output}.XXXXXX")"
local awk="$(which gawk || which nawk || echo awk)"

# ❌ WRONG
local temp=$(mktemp ${output}.XXXXXX)
```

## Error Handling Patterns

The project uses a consistent error handling vocabulary:

### shout - Print to stderr

```sh
#include "shout.sh"
shout() { printf '%s\n' "$0: $*" >&2; }

# Usage
shout "warning: file not found"
```

### barf - Fatal error (exit 111)
Exit 111 for temporary errors.

```sh
#include "barf.sh"
barf() { shout "fatal: $*"; exit 111; }

# Usage
test -f "${file}" || barf "missing required file: ${file}"
```

### usage - Usage error (exit 100)
Exit 111 for permanent errors.

```sh
#include "usage.sh"
usage() { shout "usage: $*"; exit 100; }

# Usage
test $# -gt 1 || usage "$0 sep prog [sep prog ...]"
```

### safe - Execute or barf

```sh
#include "safe.sh"
safe() { "$@" || barf "cannot $*"; }

# Usage
safe mkdir -p "$dir"
safe mv "${temp}" "${output}"
```

### catch - Fail if stderr matches regex
The `catch` function can run a command that executes a pipeline and detect errors in any pipeline component that prints a known pattern to standard error, such as commands called with `safe`.

```sh
#include "catch.sh"

# Usage - exit 111 if command writes pattern to stderr
catch "error:" some_command arg1 arg2
```

### Error Hierarchy

```
shout    → stderr message (continues)
usage    → stderr + exit 100 (usage error)
barf     → stderr + exit 111 (fatal error)
safe     → run command, barf on failure
catch    → run command, barf if stderr matches pattern
```

## Function Design

### Naming Conventions

**Library functions:** Descriptive names
```sh
atomic_to()
have_args()
pipewith()
```

**Command routing:** `do_` prefix for subcommands
```sh
do_help()
do_code()
do_deps()
do_run()
```

**Internal helpers:** `_` prefix
```sh
_mode()
```

### do_ Prefix Pattern

Programs use `do_` prefix for subcommand routing:

```sh
#!/bin/sh
#include "usage.sh"
#include "do_help.sh"

do_foo() {
  # implementation
}

do_bar() {
  # implementation
}

# Route to do_$1 function
test $# -lt 1 && usage "$0 foo|bar|help [args...]"
"do_$@"
```

The final line `"do_$@"` expands to `"do_foo" arg1 arg2` which calls the function.

### Help Documentation

Use `#_#` prefix for help text extracted by `do_help`:

```sh
#_# help
#_#   Print this helpful message
#_#
do_help() {
  sed -n 's/^#_#/ /p' "$0"
}

#_# code file...
#_#   Print the code in files, resolving includes
#_#
do_code() {
  _mode code "$@"
}

#_# pipeline sep prog [sep prog ...]
#_#
```

Help is extracted by `sed -n 's/^#_#/ /p'` - strips `#_#` prefix and prints.

Always end a block of help lines with a line containing only `#_#`.

### Function Structure

Use `#` for function comments that should not appear in `help` output. Use `#_#` for function comments that should appear in `help` output.

```sh
# function_name arg1 arg2
#   Brief description of what it does
function_name() {
  local var1="$1"
  local var2="$2"
  shift 2

  # implementation
  "$@" > "${var1}" || {
    local e=$?
    # cleanup
    exit $e
  }
}
```

**Key patterns:**
- Use `local` for function variables
- Quote all variable expansions
- Capture `$?` before it changes: `local e=$?`
- Use `{ ...; }` for multi-statement conditionals

## Code Organization

### When to Create lib/ Modules

Create new `.sh` files in `lib/` for:

1. **Reusable functions** - Used by multiple programs
2. **Composable utilities** - Small, focused purpose
3. **Error handling** - `shout`, `barf`, `usage`, `safe`, `catch`
4. **Command patterns** - `do_help`, `do_run`, `do_xrun`

**Each module does ONE thing:**
```
lib/barf.sh          - Fatal error reporting
lib/safe.sh          - Safe command execution
lib/atomic_to.sh     - Atomic file writes
lib/pipewith.sh      - Dynamic pipeline construction
```

### Include Pattern

**Source files** use `#include "filename"`:

```sh
#!/bin/sh
#include "usage.sh"
#include "do_help.sh"
#include "pipeline.sh"

# Your code here
```

**Include resolution:**
- Searches `SCRIP_PATH` (colon-separated directories)
- Falls back to `../lib` relative to script location
- Each file included only once (deduplication)
- Recursive - includes can contain includes
- Absolute paths or `./` prefix bypass `SCRIP_PATH`

A new project can borrow files located along `SCRIP_PATH`.
Borrowed files should appear in a lib/ subdirectory of the project.

### Directory Structure

```
lib/           # Reusable modules (included via #include)
src/           # Source files (contain #include directives)
bin/           # Generated executables (built from src/)
tests/         # Test suite
```

## Testing

### Test Structure

```
tests/
  run           # Executable that runs all tests
  expected      # Expected output
  output        # Actual output (generated)
  basedir/      # Test fixtures
```

### Adding Tests

**1. Add test case to `tests/run`:**

```sh
#!/bin/sh
# Test cases print to stdout
echo "==== Test description ===="
./bin/program arg1 arg2
echo ""
```

**2. Run and capture expected output:**

```sh
make build
tests/run > tests/expected
```

**3. Verify tests pass:**

```sh
make tests
# Runs: tests/run > tests/output && diff tests/output tests/expected
```

### Test Principles

- **Output-based testing** - Compare stdout to expected
- **Self-configured** - Tests include setup
- **Grouped Appropriately** - Neighboring tests may share config
- **Deterministic** - Same input always produces same output
- **Documented** - Echo description before each test

**Example from tests/run:**

```sh
echo "==== scrip deps ===="
bin/scrip deps lib/scrip.sh
echo ""

echo "==== scrip code ===="
bin/scrip code src/pipeline.sh | head -1
echo ""
```

## Quick Reference

| Pattern | Example | Notes |
|---------|---------|-------|
| Quote vars | `"${var}" "$@" "$x"` | Always quote expansions |
| Numeric test | `test $# -gt 1` | $# doesn't need quotes |
| Numeric values | `i=$(($i + 1))` | $# doesn't need quotes when i is numeric |
| String test | `test "$a" = "$b"` | Quote both sides |
| Error msg | `shout "warning"` | To stderr, continues |
| Fatal error | `barf "fatal"` | To stderr, exit 111 |
| Usage error | `usage "$0 args"` | To stderr, exit 100 |
| Safe exec | `safe mv "$a" "$b"` | Barf on failure |
| Local var | `local x="$1"` | Function-local |
| Include | `#include "foo.sh"` | Resolved via SCRIP_PATH |
| Help doc | `#_# help text` | Extracted by do_help |
| Subcommand | `do_foo() { ... }` | Called via "do_$@" |
| Save exit | `local e=$?` | Capture before it changes |

## Common Mistakes

### ❌ Unquoted Variables

```sh
# WRONG
temp=$(mktemp $output.XXXXXX)
if test -f $file
for arg in $@

# CORRECT
temp="$(mktemp "${output}.XXXXXX")"
if test -f "${file}"
for arg in "$@"
```

### ❌ Wrong Error Handler

```sh
# WRONG - inconsistent error reporting
echo "error: missing file" >&2
exit 1

# CORRECT - use project vocabulary
barf "missing file"
```

### ❌ Missing #include

```sh
# WRONG - barf not defined
barf "error"

# CORRECT - include dependencies
#include "barf.sh"
barf "error"
```

### ❌ Bashisms

```sh
# WRONG - bash-specific
[[ $x == $y ]]
function foo() { ... }
local -r readonly_var="x"

# CORRECT - POSIX sh
test "$x" = "$y"
foo() { ... }
local readonly_var="x"
```

### ❌ Test Without Building

```sh
# WRONG - stale binaries
./bin/program  # might be old version

# CORRECT - build first
make build
./bin/program
```

## Real-World Examples

### Atomic File Write

```sh
#include "atomic_to.sh"

# Write output from program to path atomically
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

# Usage
atomic_to "output.txt" command args
```

**Key patterns:**
- Quote all vars: `"$1"` `"${output}"` `"${temp}"`
- Save exit code: `local e=$?`
- Cleanup on failure: `rm -f "${temp}"`
- Exit with original code: `exit $e`

### Pipeline Construction

```sh
#include "pipewith.sh"

# Build dynamic pipeline with custom prefix
pipewith_cmd() {
  local sep="$2"
  shift 2

  local cmd=''
  local i=3
  local p='"$1"'
  for a in "$@"
  do
    if test "$a" = "${sep}"
    then
      cmd="${cmd} |"
      p='"$1"'
    else
      cmd="${cmd} ${p} \"\${$i}\""
      p=''
    fi
    i=$(($i + 1))
  done

  printf '%s\n' "${cmd}"
}

pipewith() {
  eval "$(pipewith_cmd "$@")"
}
```

**Key patterns:**
- Local vars for all state
- Arithmetic: `i=$(($i + 1))` (POSIX compliant)
- String building with `"${cmd} | ..."`
- Careful quoting in eval context

### Argument Validation

```sh
#include "usage.sh"
#include "have_args.sh"

# Return 0 if args has at least n entries
have_args() {
  test $# -ge 1 || usage "have_args count [args...]"
  test "$1" -lt $#
  return $?
}

# Usage in functions
do_process() {
  have_args 2 "$@" || usage "$0 process file1 file2"
  # process files
}
```

### File Names

Library module files use the `.sh` extension to indicate the implementation language, because the module is language specific.

Top-level command-line programs never include an extension, because that is an implementation detail and should not be exposed in the command-line interface.

## The Bottom Line

**Quote everything. Fail loudly. Compose from lib/.**

This project values:
- Strict POSIX compliance for portability
- Consistent quoting prevents word-splitting bugs
- Explicit error vocabulary makes failures clear
- Modular composition through #include
- Output-based testing for reliability

Follow these conventions and your shell code will be robust, portable, and maintainable.
