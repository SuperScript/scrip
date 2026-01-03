---
name: init-script
description: Create a new SuperScript shell script with proper structure and template
argument-hint: "[script-name] [output-path]"
allowed-tools: [Read, Write, Glob, Bash]
---

# init-script Command

Create a new SuperScript shell script following the rigorous POSIX-compliant style with proper structure, standard includes, and placeholder functions.

## Task

When the user invokes this command, create a new shell script file that adheres to the SuperScript methodology:

1. **Determine script details**:
   - Script name (from argument or ask user)
   - Output location (from argument, current directory, or ask user)
   - Purpose/description (ask user for context)

2. **Read the template**:
   - Use the Read tool to get the template from: `skills/shell-scripting/assets/template.sh`

3. **Customize the script**:
   - Replace placeholder function names with meaningful names based on user's description
   - Update help text (`#_#` comments) with actual descriptions
   - Keep all standard sections: template functions, program functions, parameters, main
   - Ensure proper shebang: `#!/bin/sh`

4. **Write the script**:
   - Use Write tool to create the script file
   - Make it executable with: `chmod +x <script-path>`

5. **Provide guidance**:
   - Explain the script structure to the user
   - Mention available stdlib functions they can include
   - Suggest next steps (implement functions, add includes, etc.)

## SuperScript Requirements

Ensure the generated script follows these rules:

- **Shebang**: Always `#!/bin/sh` (never bash)
- **Structure sections**:
  1. `#### template functions` - Standard includes
  2. `#### program functions` - Implementation functions
  3. `#### parameters` - Configuration variables
  4. `#### main` - Entry point
- **Standard includes**: At minimum include shout.sh, barf.sh, usage.sh, do_help.sh
- **Subcommand pattern**: Use `do_*` function naming for commands
- **Help documentation**: Use `#_#` prefix for help text
- **Variable quoting**: Use `"${var}"` for multi-character variables, `"$1"` for single-digit positionals

## Example Interaction

```
User: /scrip:init-script build-tool ./tools/build
Assistant: I'll create a new SuperScript for you. What is the main purpose of this build tool?
User: It should compile the project and run tests
Assistant: [Creates script with do_compile and do_test functions, writes to ./tools/build, makes executable]
```

## Available Standard Library

Reference these common stdlib functions users might need:

**Error handling**: shout.sh, barf.sh, usage.sh, do_help.sh, catch.sh, safe.sh
**File operations**: atomic_to.sh, atomic_to_mode.sh, ditto.sh, ditt.sh
**Pipelines**: pipeline.sh, pipewith.sh
**Command dispatch**: do_.sh, do_run.sh, do_xrun.sh, do_to.sh
**Validation**: have_args.sh

Suggest relevant includes based on the script's purpose.

## Tips

- Ask clarifying questions if script purpose is unclear
- Suggest meaningful function names based on user's description
- Recommend relevant stdlib includes
- Mention that the scrip build system will process `#include` directives
- Remind users to run `make build` after creating source files in `src/`
