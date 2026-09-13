# scrip

WARNING: This repo is experimental and not yet suited for production use. Interfaces may change without notice.

A library of reusable POSIX shell, make, and awk routines, and a tool to compose them into self-contained programs via `#include`.

## Why

Shell scripts duplicate the same code over and over — error handling, pipelines,
atomic writes. scrip keeps one copy of each routine in a library and gives you
the tools to recombine them into programs.

What you gain:

- You do not re-implement the basics in every new script.
- A fix to a routine reaches every program that uses it on the next build.
- The built program is one self-contained file. Copy it to a machine with
  nothing installed and it runs.

It is for anyone writing shell tools they need to ship.

## Installation

Clone the repo and build. Nothing is required beyond a POSIX sh, make, and awk.

    make all          # build bin/ from src/
    make test         # run test suite
    make install      # install to /usr/local (set PREFIX= to change)

## Day to Day

Write a source file in `src/` with `#include` lines for the routines you want.
Run `make all` to build it into `bin/`. Ship the built file — it stands alone.

For a project outside scrip, use `scrip borrow` to copy the routines you need
into it.

## The `scrip` command

`scrip` is the core tool. It resolves `#include` directives to produce standalone programs from modular source files.

    scrip code file       # print file with all includes resolved
    scrip deps file       # list included dependencies in order
    scrip prog out src    # build executable from source
    scrip borrow dir file # copy dependencies into a directory
    scrip list [regex]    # list available library modules
    scrip docs [path]     # print help documentation from files
    scrip make target     # emit a Makefile rule for a target
    scrip path            # print the library search path
    scrip help            # print help

When no file arguments are given, `code` and `deps` read from stdin. Set `SCRIP_PATH` to a colon-separated list of directories to search for includes; the default is `share/scrip` relative to the scrip binary.

## Include Resolution

A line of the form `#include "filename"` is replaced with the contents of the named file. Includes are resolved recursively. Each file is included only the first time it is encountered.

`SCRIP_PATH` directories are searched for relative paths. Absolute paths and paths starting with `./` bypass the search.

## Library

Library modules live in `share/scrip/`. The file extension identifies the language: `.sh` for shell, `.mk` for make, `.awk` for awk.

### Error handling

| Function | Behavior |
|----------|----------|
| `shout` | Print message to stderr |
| `barf` | Print fatal message to stderr, exit 111 |
| `usage` | Print usage message to stderr, exit 100 |
| `safe` | Run command, barf on failure |
| `catch` | Run command, exit 111 if stderr matches a pattern |

### Pipelines

| Function | Behavior |
|----------|----------|
| `pipe_with cmd sep args...` | Build and eval a pipeline, applying `cmd` to each segment |
| `pipeline sep prog...` | Pipeline of external commands (via `do_run`) |
| `pipe sep func...` | Pipeline of `do_`-prefixed shell functions (via `do_`) |

### Command lists

| Function | Behavior |
|----------|----------|
| `and_with cmd sep args...` | Build and eval an and-list, applying `cmd` to each segment |
| `and sep func...` | And-list of `do_`-prefixed shell functions (via `do_`) |
| `or_with cmd sep args...` | Build and eval an or-list, applying `cmd` to each segment |
| `or sep func...` | Or-list of `do_`-prefixed shell functions (via `do_`) |
| `sequence_with cmd sep args...` | Build and eval a sequence, applying `cmd` to each segment |
| `sequence sep func...` | Sequence of `do_`-prefixed shell functions (via `do_`) |
| `background prog` | Run command in the background |
| `do_background cmd` | Background via `do_` dispatch |
| `subshell prog` | Run command in a subshell |
| `do_subshell cmd` | Subshell via `do_` dispatch |
| `group prog [args...]` | Run remaining arguments as a command group |
| `do_group cmd` | Command group via `do_` dispatch |

### Dispatchers

| Function | Behavior |
|----------|----------|
| `do_ prog` | Call `do_prog` (shell function dispatch) |
| `do_run prog` | Call `prog` (external command dispatch) |
| `do_xrun prog` | Run with explicit argument passing |
| `do_env VAR=val... cmd` | Export variables, then dispatch |
| `do_set -opt... cmd` | Apply shell options, then dispatch |

### File output

| Function | Behavior |
|----------|----------|
| `atomic_to path cmd` | Write command output to path atomically |
| `atomic_to_mode path mode cmd` | Atomic write with chmod |
| `do_to path cmd` | Atomic write via `do_` dispatch |
| `do_to_mode path mode cmd` | Atomic write with mode via `do_` dispatch |

### Redirection

| Function | Behavior |
|----------|----------|
| `append_to path prog` | Append command output to path |
| `append_to_mode path mode prog` | Append, then chmod |
| `do_append_to path cmd` | Append via `do_` dispatch |
| `do_append_to_mode path mode cmd` | Append with mode via `do_` dispatch |
| `from path prog` | Read command stdin from path |
| `do_from path cmd` | Read stdin from path via `do_` dispatch |
| `err_to path prog` | Write command stderr to path |
| `err_to_mode path mode prog` | Write stderr, then chmod |
| `do_err_to path cmd` | Write stderr via `do_` dispatch |
| `do_err_to_mode path mode cmd` | Write stderr with mode via `do_` dispatch |
| `err_append_to path prog` | Append command stderr to path |
| `do_err_append_to path cmd` | Append stderr via `do_` dispatch |
| `fd_to n path prog` | Write fd n to path (`n` must be digits) |
| `do_fd_to n path cmd` | Write fd n via `do_` dispatch |
| `fd_from n path prog` | Read fd n from path |
| `do_fd_from n path cmd` | Read fd n via `do_` dispatch |
| `fd_dup_to n m prog` | Duplicate fd m onto n (`m` may be `-` to close n) |
| `do_fd_dup_to n m cmd` | Duplicate onto n via `do_` dispatch |
| `fd_dup_from n m prog` | Duplicate fd m onto n for input (`m` may be `-`) |
| `do_fd_dup_from n m cmd` | Duplicate from m via `do_` dispatch |

### Iteration

| Function | Behavior |
|----------|----------|
| `do_while cmd` | For each stdin line, call `do_cmd line` |
| `do_foreach cmd args` | For each stdin line, call `do_cmd line args` |

### Utilities

| Function | Behavior |
|----------|----------|
| `have_args count args...` | Return 0 if enough arguments provided |
| `do_help` | Print `#_#` help text from a file |
| `ditto` | Print arguments to stdout |
| `ditt` | Print arguments to stdout without newline |

### Make modules

| Module | Purpose |
|--------|---------|
| `help.mk` | Standard help target from `#_#` comments |
| `install.mk` | Standard `install` and `uninstall` targets for `bin` and `share` |
| `test.mk` | Test runner with diff against expected output |
| `needvar.mk` | Variable validation |
| `template.mk` | Minimal Makefile template |
| `tex-pdf.mk` | LaTeX to PDF workflow |

## Writing a program

Create a source file in `src/` with `#include` directives:

```sh
#!/bin/sh
#include "usage.sh"
#include "do_help.sh"
#include "do_pipe.sh"

do_greet() { printf 'hello %s\n' "$1"; }
do_shout() { tr '[a-z]' '[A-Z]'; }

test $# -lt 1 && usage "$0 command [args...]"
"do_$@"
```

Build it with `scrip prog bin/myprog src/myprog` or just `make all`.

## Help documentation

Lines beginning with `#_#` are extracted as help text by `do_help` and `scrip docs`:

```sh
#_# greet name
#_#   Say hello to name
#_#
do_greet() { printf 'hello %s\n' "$1"; }
```

## License

BSD 3-Clause. See LICENSE.
