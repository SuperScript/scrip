# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

**scrip** is an experimental shell script composition system that provides reusable script components through an include mechanism. The system processes `#include "filename"` directives to build self-contained executables from modular shell script libraries.

## Build & Test Commands

```bash
# Build all executables from src/*.sh
make build

# Build a specific executable (e.g., pipeline)
make build target=pipeline

# Run test suite (tests use diff against tests/expected)
make tests

# Run tests and see output (for debugging test failures)
tests/run

# Clean build artifacts
make clean

# Install to PREFIX (default: /usr/local)
make install

# Uninstall from PREFIX
make uninstall

# Show available make targets
make help

# Create demo GIFs
make demos
```

## Core Architecture

### Include Resolution System

The `bin/scrip` preprocessor is the heart of this system:

- **Syntax**: `#include "filename"` in shell scripts
- **Path resolution**: Uses `SCRIP_PATH` environment variable (colon-separated directories)
  - Default: `$(dirname $(dirname $0))/share/scrip` (sibling to bin/scrip)
- **Deduplication**: Each file included only once (subsequent includes ignored)
- **Recursive**: Included files can themselves contain includes
- **Absolute/relative paths**: `./` prefix or absolute paths bypass SCRIP_PATH

**Scrip modes:**
- `scrip code file...` - Process includes and output executable code
- `scrip deps file...` - List all dependencies (files that would be included)
- `scrip borrow destdir file...` - Copy all dependencies to destdir
- `scrip make target...` - Generate Makefile rules for building targets
- `scrip docs file...` - Extract help text (lines starting with `#_#`)

Example:
```bash
SCRIP_PATH=./share/scrip bin/scrip code src/pipeline.sh > bin/pipeline
```

### Directory Structure

- **`share/scrip/`**: Reusable shell script modules (imported via #include)
  - Error handling: `barf.sh`, `safe.sh`, `catch.sh`, `shout.sh`, `usage.sh`
  - File operations: `atomic_to.sh`, `atomic_to_mode.sh`, `ditto.sh`, `ditt.sh`
  - Pipeline utilities: `pipewith.sh`, `pipeline.sh`
  - Command routing: `do_.sh`, `do_run.sh`, `do_xrun.sh`, `do_help.sh`, `do_template.sh`
  - Argument validation: `have_args.sh`
  - AWK utilities: `barf.awk`, `shout.awk`
  - Core preprocessor: `scrip.sh`

- **`src/`**: Source files for executables (contain includes, get processed into `bin/`)
- **`bin/`**: Generated executables (built from `src/` via `make build`)
- **`tests/`**: Test suite with expected output comparison
- **`mk/`**: Makefile utilities for help system
- **`build/`**: Build artifacts and generated Makefiles

### Key Utilities

#### `pipewith`
Dynamic pipeline construction with custom command prefixes:
```bash
pipewith do_ :: echo "hello" :: sed 's/h/H/'
# Builds: do_echo "hello" | do_sed 's/h/H/'
```

#### `pipeline`
Simplified pipewith using `do_run` (which wraps commands for execution):
```bash
pipeline :: echo "hello" :: sed 's/h/H/'
```

#### `atomic_to`
Atomic file writes (write to temp, move on success, cleanup on failure):
```bash
atomic_to "output.txt" command args
```

#### Error handling
- `safe cmd args` - Execute command, barf if it fails
- `barf "message"` - Print fatal error and exit 111
- `shout "message"` - Print message to stderr
- `catch regex cmd` - Exit 111 if stderr matches regex

#### Command routing (`do_` prefix pattern)
Libraries use a `do_` prefix convention for subcommand routing:
- `do_help` - Print help from `#_#` comment markers
- `do_run` - Execute command directly
- `do_xrun` - Execute command with xargs
- Programs check for `do_$1` functions to implement subcommands

## Development Workflow

1. **Modify source**: Edit files in `src/` or libraries in `share/scrip/`
2. **Build**: Run `make build target=<name>` to process includes and generate executables
3. **Test**: Run `make tests` to verify changes
4. **Iterate**: Tests use diff against `tests/expected` for validation

### Bootstrap Process

The `bin/scrip` preprocessor is self-hosting and built in a special way:

```bash
/bin/sh -c '. share/scrip/scrip.sh && do_code src/scrip' > bin/scrip.new
chmod a+x bin/scrip.new && mv bin/scrip.new bin/scrip
```

This sources `scrip.sh` directly and calls its `do_code` function, avoiding the need for an existing `bin/scrip` to build itself.

### Test Methodology

Tests are diff-based:
- `tests/run` executes all test cases and prints output
- Output is compared against `tests/expected` using `diff`
- Any difference indicates test failure
- To update expected output after intentional changes: `tests/run > tests/expected`

### Adding new library modules

Create `.sh` files in `share/scrip/` that can be included via `#include`:
```bash
# In share/scrip/mynew.sh
my_function() {
  # implementation
}
```

Use in source:
```bash
#!/bin/sh
#include "mynew.sh"
my_function
```

### Help documentation

Use `#_#` prefix for embedded help text that's extracted by `do_help`:
```bash
#_# command arg1 arg2
#_#   Description of what this does
```

## Current State

**Last Updated:** 2025-11-03 03:39
**Branch:** master
**Status:** dirty

### Active Work

In this session we initialized ccode and created CONTEXT.md.

### Next Steps

Design a tail-execution program analogous to pipewith.

### Open Questions

The main blocker is the need to experiment with how to thread results from each program in the tail exec pipeline.

### Recent Changes

- CLAUDE.md (untracked)

**Last Commit:** c769a0a - Update help for borrow
