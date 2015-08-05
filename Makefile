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
	.dot/script/link-git
	.dot/script/link

install:
	.dot/script/install-deps
	.dot/script/install

setshell:
	.dot/script/setshell

defaults:
	.dot/script/defaults

apps:
	.dot/script/apps


# -- Helpers ------------------------------------------------------------------

_dot-start:
	.dot/script/dot-start

_dot-finish:
	.dot/script/dot-finish
