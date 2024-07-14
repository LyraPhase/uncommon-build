Uncommon Build
==============

A curiously uncommon build framework... 🧐

[![Spiral eye with Monocle](./assets/Spiral_eye_Monocle.svg)](./assets/Spiral_eye_Monocle.svg)

WTF?
----

`uncommon-build` is a set of handcrafted GNU `Makefile` includes for building
software projects. It may be installed as a `git` `submodule` to enable your
project `Makefile`s to be more trim, elegant, and classy. 🤵‍♂️

### Prequisites

- An initialized `git` repo
- Ability to create a file in this repo: `.uncommon-build-init.mk`
- GNU `make` command
- Bash shell
  - `bash` command must be available
  - Not necessarily as your default shell
- POSIX shell utilities: `sed`, `grep`, `echo`, `cd`, `rm`, `mkdir`, `awk`,
  `sort`, `find`, `xargs`, `basename`

How Do That?! 🤔
----------------

The simple way to accomplish this, naturally, is to add the following file to
your repo: `.uncommon-build-init.mk` [$^{...You\ \textbf{\textit{doOo}
\ have\ a\ git\ repo\ already,\ yes?}$][2]

```bash
curl -Ls -o .uncommon-build-init.mk https://bit.ly/3K5HcJO
```

Then, one must simply 🤌 add the following line to your `Makefile`:

```make
include .uncommon-build-init.mk
```

This single include line should generally be placed at the top of your
`Makefile`.  However, if one wishes to configure any variables or
override defaults, then one must do so before including `main.mk`.

Finally, one must run:

```shell
make stylish
```

What Does It Do? 🙋
-------------------

This short GNU `Makefile` code snippet creates a target + recipe, `stylish`
to install via `make stylish`.  It's recommended to use the dot `.` prefix for
`.uncommon-build-init.mk`, so the installation is as unobtrusive and tucked
away as possible.  This also allows for an elegant one-liner in your main
`Makefile`: `include .uncommon-build-init.mk`

The recipe checks for existence of `.uncommon-build`, and installs it if
not found.

If `.uncommon-build` is found, the `.gitmodules` definition is updated.
If the `.uncommon-build` directory is missing the submodule will be added for
you, and will be automatically committed.

**Default Targets**: This `Makefile` framework creates some basic targets for
use when building Docker images:

- `help`: Output all make targets with help text.
  Hint: Add your own help text by appending `## Help text here`,
  Or prevent a target from showing up in `help` by appending: `## no-help` to
  the recipe definition line (e.g.: `foo: foo.c ## no-help`)
- `build`: Builds the Docker image
- `save-image`: Saves the Docker image via `docker save`.
  Output defaults to: `$(top_builddir)/.uncommon-build-stamps/$(REPO_NAME).tar`
- `push`: Pushes the Docker image to a Registry.
  Default: `docker.io/$(REPO_NAME):$(IMAGE_TAG)`
  where `IMAGE_TAG` is a 12-character short commit SHA
- `compile`: Compile the project's source files.

**Language Specific Includes**: _When using specific programming languages,
set `$(PROJECT_LANG)` before including `main.mk`_. The list of supported
languages will grow over time.  Currently supported languages are:

- `go`: [GoLang][1]

Updating the `.uncommon-build` Submodule
----------------------------------------

To automatically update `uncommon-build` to latest, run:

```bash
make update-uncommon-build
```

This target executes the following steps:

1. Change directory into the `.uncommon-build`
  submodule folder: `cd .uncommon-build`
2. Fetch & Update the `git` submodule to latest
3. Commit the `.uncommon-build` and `.gitmodules` file changes.

_NOTE_: If you need to update `uncommon-build` to some version
different than `origin/main` branch, set the `UNCOMMON_BUILD_REF` variable.
This accepts any `git` ref.
For example: a branch name, tag, or commit SHA.

[1]: https://go.dev/
[2]: https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository
