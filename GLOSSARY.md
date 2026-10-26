# Dotfiles

The parts of this repo, as its scripts and docs name them.

## Language

**Topic**:
A folder at the root about one subject (git, zsh, macos), holding
everything the dotfiles do for it: its links, its packages, its installer,
its shell files.
_Avoid_: module, area

**Core**:
What the dotfiles need to run, under `.dot/`: the `dot` steps with their
helpers, and the core topics that bring the shell and the package managers.
It runs before any topic.
_Avoid_: framework, base

**Step**:
One action `dot` runs, a target of the Makefile: `link`, `install`,
`defaults`.
_Avoid_: task, command

**Link**:
A file of a topic placed in the home folder: a `.symlink` into `$HOME`, a
`.csymlink` into `$HOME/.config`, or a line of the topic's `links`.

**Manifest**:
A topic's `packages` file: one `driver package` line per package the topic
needs.
_Avoid_: package list, Brewfile

**Driver**:
The part of `pinstall` that knows one manager: how to list what it has and
how to install what is missing. A manifest line names the driver.
_Avoid_: provider, adapter, backend

**Manager**:
The tool a driver runs: brew, gem, npm, uv, mas, code.
_Avoid_: package system
