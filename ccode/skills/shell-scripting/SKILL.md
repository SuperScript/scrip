---
name: shell-scripting
description: Generate POSIX shell scripts following UNIX programming principles and a rigorous coding style. Use when: (1) creating or updating shell scripts; (2) when working on .sh files; (3) when working on files with #!/bin/sh shebang lines. Do not use when: (1) asked to create a Bash script.
---

# Shell Scripting

Generate POSIX-compliant shell scripts that follow UNIX philosophy and rigorous engineering practices.

## Core Principles

Apply these principles to all shell scripts:

1. **UNIX Philosophy**: Silent success, errors to stderr, consistent exit codes
2. **Rigorous Quoting**: Always quote variables (`"${var}"`, `"$@"`)
3. **Standard Structure**: Template functions → Program functions → Parameters → Main
4. **Modular Design**: Use `#include` directives for reusable components
5. **Self-Documenting**: Use `#_#` prefix for help text
6. **Atomic Operations**: Safe file writes using temp files + mv

## Quick Start

### Basic Script Structure

Every script follows this template:

```sh
#!/bin/sh

#### template functions

#include "shout.sh"
#include "barf.sh"
#include "usage.sh"
#include "do_help.sh"

#### program functions

#_# command args...
#_#   Description of command
#_#
do_command() {
  # implementation
}

#### parameters

# Configuration variables here

#### main

test $# -gt 0 || usage "$0 command [args]"

"do_$@"
```

### Standard Error Functions

```sh
shout() { printf '%s\n' "$0: $*" >&2; }        # Print to stderr
barf() { shout "fatal: $*"; exit 111; }        # Fatal error, exit 111
usage() { shout "usage: $*"; exit 100; }       # Usage error, exit 100
```

### Variable Quoting Rules

```sh
# Correct - always quote, use braces for multi-character names
local filename="$1"
test -f "${filename}"
"${command}" "${arg1}" "${arg2}"

# Single-digit positional parameters don't need braces
shift_count="$1"
process "$2" "$3"

# Special cases
"$@"  # All args as separate quoted words
"$*"  # All args as single word
$#    # Number of args (safe unquoted)
$?    # Exit code (safe unquoted)
$$    # Process ID (safe unquoted)

# Exception: Intentional unquoted usage must be commented
for file in ${pattern}  # intentional: word splitting needed
do
  process "${file}"
done
```

## Essential Patterns

### Subcommand Dispatch

```sh
#_# build
#_#   Build the project
#_#
do_build() {
  make
}

#_# test
#_#   Run tests
#_#
do_test() {
  ./run-tests
}

#### main
test $# -gt 0 || usage "$0 build|test|help"
"do_$@"
```

### Atomic File Operations

```sh
#include "atomic_to.sh"

# Write atomically: creates temp → writes → moves
atomic_to "output.txt" sed 's/foo/bar/g' input.txt
atomic_to "config.json" jq '.setting = "value"' raw.json
```

### Error Detection

```sh
# Fail on error
command || barf "command failed"

# Check file exists
test -f "$file" || barf "file not found: $file"

# Validate arguments
test $# -eq 2 || usage "$0 source dest"
```

### Pipeline Construction

```sh
#include "pipeline.sh"

# Build pipelines with custom separator
pipeline '::' cat file.txt '::' grep pattern '::' sort
```

## Standard Library

The `assets/stdlib/` directory contains reusable shell functions:

**Core Functions:**
- `shout.sh` - Print messages to stderr
- `barf.sh` - Fatal error handling
- `usage.sh` - Usage error handling
- `do_help.sh` - Self-documenting help extraction

**File Operations:**
- `atomic_to.sh` - Atomic file writes
- `atomic_to_mode.sh` - Atomic writes with permissions

**Utilities:**
- `pipeline.sh` - Pipeline construction
- `pipewith.sh` - Flexible pipeline builder
- `catch.sh` - Error pattern detection
- `safe.sh` - Safe command execution
- `do_.sh` - Subcommand dispatcher
- `do_run.sh`, `do_xrun.sh` - Command runners
- `have_args.sh` - Argument validation

Include these in scripts using `#include` directives:

```sh
#include "shout.sh"
#include "barf.sh"
#include "atomic_to.sh"
```

## Detailed Documentation

For comprehensive guidelines and patterns:

- **[references/style-guide.md](references/style-guide.md)** - Complete style conventions, quoting rules, standard functions, and UNIX philosophy application
- **[references/patterns.md](references/patterns.md)** - Common patterns, complete examples, error handling, file operations, and text processing

Read these references when:
- Starting a complex script
- Unsure about a pattern
- Need examples of specific functionality
- Want to understand the rationale behind conventions

## Templates and Tools

### Script Template

Use `assets/template.sh` as a starting point for new scripts. It includes:
- Standard structure
- Common includes
- Placeholder functions
- Main dispatcher

### Initialization Script

Run `scripts/init-script.sh` to create new scripts:

```sh
scripts/init-script.sh my-script output-dir/
```

Creates a properly structured script ready for implementation.

## Exit Codes

Use consistent exit codes:
- **0** - Success (silent)
- **100** - Usage error (wrong arguments)
- **111** - Fatal error (runtime failure)

## Workflow

1. **Start with template**: Use `assets/template.sh` or run `scripts/init-script.sh`
2. **Include standard functions**: Add `#include` directives for needed utilities
3. **Define program functions**: Implement `do_*` functions with `#_#` help text
4. **Add parameters**: Define configuration variables in parameters section
5. **Implement main**: Add argument validation and dispatch logic
6. **Test error paths**: Verify `barf()` and `usage()` work correctly
7. **Verify quoting**: Ensure all variables are quoted properly

## Common Scenarios

### Simple utility script
Use template with basic includes (shout, barf, usage, do_help)

### File processing script
Include atomic_to.sh for safe file operations

### Pipeline builder
Include pipeline.sh and pipewith.sh for composable commands

### Multi-command tool
Use subcommand pattern with do_* functions and main dispatcher

### Build/deployment automation
Combine atomic operations, error checking, and subcommand dispatch
