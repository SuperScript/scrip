# scrip

WARNING: This repo is experimental and not yet suited for production use. Interfaces may change without notice.

This repository contains scripts that have proven useful over time, and routines to construct programs from them. The goals is to facilitate easy and self-contained reuse of these routines in scripts, with a common source maintained in one place.

Script inclusion is indicated by a line of the form `#include "filename"`. In the initial version this is the only form. In future versions additional comment conventions may be added.

## Include Resolution

The scrip system provides a program that processes include statements recursively. When it encounters a line containing `#include "filename"`, it replaces that line with the entire contents of the specified file. If the included file itself contains include statements, those are resolved recursively as well.

Each file is included only the first time an include statement for that file is encountered. Subsequent include statements for the same file are ignored.

The `SCRIP_PATH` environment variable holds a colon-separated list of directories to search for relative file paths. Absolute paths or relative paths starting with `./` do not use `SCRIP_PATH`.

## TODO

- [x] Use sibling lib/ as path when none set.
- [x] Add borrow mode.
- [x] Add make mode to create make target for program.
- [x] Sort out default lib question.
- [ ] Add install target, with PREFIX.
- [ ] Split shell-scripting skill into shell-scripting, shell-libraries, shell-programs.
