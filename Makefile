.SILENT:
.PHONY: dot
.PHONY: run osxrun
.PHONY: zeroday link install defaults apps
.PHONY: _dot-start _dot-finish


# -- Make dot -----------------------------------------------------------------

dot: _dot-start zeroday run _dot-finish


# -- Workflows ----------------------------------------------------------------

run: link install
osxrun: apps install defaults


# -- Steps --------------------------------------------------------------------

zeroday:
	.dot/zeroday

link:
	.dot/link-git
	.dot/link

install:
	.dot/install-deps
	.dot/install

defaults:
	.dot/defaults

apps:
	.dot/apps


# -- Helpers ------------------------------------------------------------------

_dot-start:
	.dot/dot-start

_dot-finish:
	.dot/dot-finish
