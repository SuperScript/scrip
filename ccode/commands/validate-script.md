---
name: validate-script
description: Validate a shell script for SuperScript compliance and style adherence
argument-hint: "[script-path]"
allowed-tools: [Read, Grep, Bash]
---

# validate-script Command

Validate a shell script against SuperScript standards: POSIX compliance, rigorous quoting, proper structure, and coding conventions.

## Task

When the user invokes this command, perform comprehensive validation of a shell script:

1. **Identify the script**:
   - Use script path from argument if provided
   - If no argument, ask user which script to validate
   - Support validating current open file if in context

2. **Read the script**:
   - Use Read tool to load the script contents

3. **Perform validation checks**:

   **Critical Issues (Must Fix)**:
   - ✗ Shebang is not `#!/bin/sh` (check for `#!/bin/bash`, `#!/usr/bin/env bash`, etc.)
   - ✗ Uses Bash-specific features (`[[`, `function` keyword, `${var,,}`, arrays, etc.)
   - ✗ Unquoted multi-character variables (look for `$var` instead of `"${var}"`)
   - ✗ Missing required structure sections (`#### template functions`, `#### program functions`, `#### parameters`, `#### main`)
   - ✗ Uses non-POSIX commands (bash built-ins that aren't POSIX)

   **Style Issues (Should Fix)**:
   - ⚠ Inconsistent exit codes (should be 0, 100, or 111)
   - ⚠ Missing help documentation (`#_#` comments for do_* functions)
   - ⚠ Direct echo instead of printf for output
   - ⚠ Single-character variable names without braces (`$v` should be `"${v}"` for multi-char, or use better names)
   - ⚠ Missing standard error functions (should include shout, barf, usage)
   - ⚠ Unsafe file operations (not using atomic_to for file writes)

   **Best Practices (Optional)**:
   - ℹ Could use `do_*` naming pattern for subcommands
   - ℹ Could benefit from additional stdlib includes
   - ℹ Consider adding more `#_#` help documentation
   - ℹ Functions could use `local` for variables

4. **Report findings**:
   - Group issues by severity (Critical, Style, Best Practices)
   - For each issue, provide:
     - Line number(s) where it occurs
     - Description of the problem
     - Suggested fix with example
   - Summarize: "✓ Passed" or "✗ Failed" with issue count

5. **Offer fixes**:
   - Ask if user wants you to fix the issues automatically
   - If yes, apply fixes using Edit tool
   - Explain each fix as you make it

## Validation Examples

### Critical Issue Example

```
Line 15: ✗ CRITICAL: Unquoted variable
  Found:    rm $filename
  Fix:      rm "${filename}"
  Reason:   Unquoted variables break with spaces/special chars
```

### Style Issue Example

```
Line 42: ⚠ STYLE: Using echo instead of printf
  Found:    echo "Error: file not found"
  Fix:      printf '%s\n' "Error: file not found"
  Reason:   printf is more portable and predictable
```

### Bash Detection Example

```
Line 1: ✗ CRITICAL: Wrong shebang
  Found:    #!/bin/bash
  Fix:      #!/bin/sh
  Reason:   SuperScript requires POSIX shell, not Bash

Line 23: ✗ CRITICAL: Bash-specific syntax
  Found:    if [[ "$var" == "value" ]]
  Fix:      if test "$var" = "value"
  Reason:   [[ ]] is Bash-only; use test or [ ] with =
```

## Common Patterns to Check

**Unquoted variables**:
- Look for: `$var`, `${var}`, `$variable` (without quotes)
- Exceptions: `$#`, `$?`, `$$`, `$!` (safe unquoted)
- Pattern: Variables in command arguments, test conditions, assignments

**Bash-specific features**:
- `[[`, `function` keyword, `{1..10}`, `${var^^}`, `declare`, `local -r`
- Arrays: `arr=(...)`, `${arr[@]}`
- Process substitution: `<(...)`, `>(...)`
- `=~` operator, `&>>` redirect

**Structure violations**:
- Missing section markers
- Sections in wrong order
- Missing includes for used functions

## Tips

- Be thorough but not overwhelming - group similar issues
- Prioritize critical issues over style preferences
- Reference specific line numbers for all findings
- Provide concrete fix examples
- Offer to fix automatically when appropriate
- Explain the "why" behind SuperScript rules
- Use the style-guide.md and patterns.md from the skill for reference
