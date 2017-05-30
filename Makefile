.SILENT:
.PHONY: dot
.PHONY: run osxrun
.PHONY: link install setshell defaults apps
.PHONY: _dot-start _dot-finish


# -- Make dot -----------------------------------------------------------------

dot: _dot-start run setshell _dot-finish


# -- Workflows ----------------------------------------------------------------

run: link install
osxrun: apps defaults


# -- Steps --------------------------------------------------------------------

link:
	.dot/dot/scripts/link-git
	.dot/dot/scripts/link

install:
	.dot/dot/scripts/install-deps-core
	.dot/dot/scripts/install-deps
	.dot/dot/scripts/install

setshell:
	.dot/dot/scripts/setshell

defaults:
	.dot/dot/scripts/defaults

apps:
	.dot/dot/scripts/apps


# -- Helpers ------------------------------------------------------------------

_dot-start:
	.dot/dot/scripts/dot-start

_dot-finish:
	.dot/dot/scripts/dot-finish
