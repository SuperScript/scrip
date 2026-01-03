---
name: refactor-to-superscript
description: Convert an existing shell script to SuperScript style (COMING SOON - stub implementation)
argument-hint: "[script-path]"
allowed-tools: [Read]
---

# refactor-to-superscript Command

**Status**: STUB - Coming in future version

Convert an existing Bash or POSIX shell script to SuperScript style with proper structure, quoting, and conventions.

## Current Implementation

This command is currently a stub and will inform users that the feature is under development.

When invoked:

1. **Inform the user**:
   ```
   The refactor-to-superscript command is currently under development.

   For now, you can:
   - Use /scrip:validate-script to identify issues in your script
   - Manually apply fixes based on validation suggestions
   - Use /scrip:init-script to create a new SuperScript and migrate logic

   This feature will support automatic refactoring in a future release:
   - Convert Bash scripts to POSIX sh
   - Add proper structure sections
   - Fix variable quoting
   - Add standard error handling
   - Convert to do_* subcommand pattern
   ```

2. **Offer alternatives**:
   - Suggest using validate-script first to see what needs fixing
   - Offer to manually help fix specific issues if user wants
   - Can guide through manual refactoring process

## Planned Future Implementation

When fully implemented, this command will:

1. **Analyze the script**:
   - Detect Bash vs POSIX features
   - Identify structure and patterns
   - Catalog functions and variables

2. **Plan refactoring**:
   - Map Bash features to POSIX equivalents
   - Design SuperScript structure
   - Identify needed includes

3. **Transform the script**:
   - Convert shebang to `#!/bin/sh`
   - Replace Bash-specific syntax with POSIX
   - Add structure section markers
   - Fix variable quoting
   - Add standard error functions
   - Convert to do_* pattern if applicable
   - Add #_# help documentation

4. **Preserve functionality**:
   - Maintain original behavior
   - Keep logic intact
   - Preserve comments and documentation

5. **Validate and test**:
   - Run validation on converted script
   - Suggest testing approach
   - Highlight areas needing manual review

## Bash to POSIX Conversion Examples

Future implementation will handle conversions like:

```bash
# Bash: [[ ]] syntax
if [[ "$var" == "value" ]]; then

# POSIX: test syntax
if test "$var" = "value"; then
```

```bash
# Bash: arrays
files=(*.txt)
for file in "${files[@]}"; do

# POSIX: globbing
for file in *.txt; do
```

```bash
# Bash: string manipulation
echo "${var^^}"

# POSIX: external command
echo "$var" | tr '[:lower:]' '[:upper:]'
```

## Notes for Future Development

When implementing this command:
- Create backup of original script
- Support incremental refactoring (don't force all changes at once)
- Flag changes that need human review
- Generate diff showing changes
- Provide testing recommendations
- Handle edge cases gracefully (complex Bash scripts may not have perfect POSIX equivalents)
