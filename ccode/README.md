# scrip - Claude Code Plugin

SuperScript shell scripting assistant for creating POSIX-compliant scripts with rigorous style, modular composition via `#include`, and automated validation.

## Overview

This plugin provides comprehensive support for developing shell scripts in the **SuperScript** style:
- **POSIX compliance**: Bourne shell (`#!/bin/sh`) + POSIX + `local` keyword only (never Bash)
- **Rigorous quoting**: All variables quoted (`"${var}"`, `"$@"`)
- **Standard structure**: Template functions → Program functions → Parameters → Main
- **Modular design**: Reusable components via `#include` directives
- **Self-documenting**: Help text with `#_#` prefix
- **Atomic operations**: Safe file writes using temp files + mv

## Features

### Skills
- **shell-scripting**: Comprehensive knowledge of SuperScript style, patterns, and standard library

### Commands
- `/scrip:init-script` - Create new SuperScript from template
- `/scrip:validate-script` - Check script for SuperScript compliance
- `/scrip:refactor-to-superscript` - Convert existing scripts to SuperScript style

### Agents
- **script-validator**: Proactively reviews shell scripts for compliance after creation/modification

### Hooks
- **PreToolUse validation**: *(Coming soon)* Will automatically check `.sh` files for common issues

## Installation

### Option 1: Use with Repository (Recommended for Contributors)

When working in the scrip repository:

```bash
cd /path/to/scrip
claude-code --plugin-dir ./ccode
```

Or set it permanently in your shell:

```bash
export CLAUDE_PLUGIN_DIR="/path/to/scrip/ccode"
claude-code
```

### Option 2: Install to User Plugins Directory

Copy the plugin to your Claude plugins directory:

```bash
# Create plugins directory if it doesn't exist
mkdir -p ~/.claude/plugins

# Copy plugin
cp -r /path/to/scrip/ccode ~/.claude/plugins/scrip

# Use Claude Code (plugin auto-loads)
claude-code
```

## Usage

### Creating a New Script

```bash
# In Claude Code session
/scrip:init-script
```

Claude will create a properly structured SuperScript with:
- Standard template structure
- Common includes (shout, barf, usage, do_help)
- Placeholder functions
- Main dispatcher

### Validating Scripts

The plugin validates automatically, but you can also check manually:

```bash
/scrip:validate-script
```

Checks for:
- Correct shebang (`#!/bin/sh`, not `#!/bin/bash`)
- Proper variable quoting
- Standard structure sections
- Exit code conventions (0, 100, 111)
- Include directive syntax

### Automatic Validation

The plugin automatically validates when you:
1. Write or edit `.sh` files
2. Create new scripts

The **script-validator** agent will proactively review scripts and suggest improvements.

## SuperScript Quick Reference

### Basic Structure

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
barf() { shout "fatal: $*"; exit 111; }        # Fatal error
usage() { shout "usage: $*"; exit 100; }       # Usage error
```

### Variable Quoting

```sh
# Correct - always quote, use braces for multi-character names
local filename="$1"
test -f "${filename}"
"${command}" "${arg1}" "${arg2}"

# Single-digit positional parameters don't need braces
shift_count="$1"
process "$2" "$3"
```

## Standard Library

The plugin includes a complete standard library in `skills/shell-scripting/assets/stdlib/`:

- `shout.sh`, `barf.sh`, `usage.sh` - Error handling
- `atomic_to.sh`, `atomic_to_mode.sh` - Safe file operations
- `pipeline.sh`, `pipewith.sh` - Pipeline construction
- `do_.sh`, `do_run.sh`, `do_xrun.sh` - Command dispatch
- `safe.sh`, `catch.sh` - Safe execution
- `have_args.sh` - Argument validation

## Documentation

Full documentation available in:
- `skills/shell-scripting/SKILL.md` - Quick reference
- `skills/shell-scripting/references/style-guide.md` - Complete style guide
- `skills/shell-scripting/references/patterns.md` - Common patterns and examples

## Exit Codes

- **0** - Success (silent)
- **100** - Usage error (wrong arguments)
- **111** - Fatal error (runtime failure)

## Contributing

When contributing to this plugin:
1. Follow the SuperScript style for any shell scripts
2. Test with `make tests` in the repository root
3. Update documentation as needed
4. Validate plugin structure before committing

## License

BSD 3-Clause License - See repository LICENSE file
