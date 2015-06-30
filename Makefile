.SILENT:
.PHONY: dot
.PHONY: run osxrun
.PHONY: zeroday link install defaults apps
.PHONY: _dot-start _dot-finish


# -- Make dot -----------------------------------------------------------------

dot: _dot-start zeroday run _dot-finish


# -- Workflows ----------------------------------------------------------------

run: link install
osxrun: apps defaults


# -- Steps --------------------------------------------------------------------

zeroday:
	.dot/script/zeroday

link:
	.dot/script/link-git
	.dot/script/link

install:
	.dot/script/install-deps
	.dot/script/install

defaults:
	.dot/script/defaults

apps:
	.dot/script/apps


# -- Helpers ------------------------------------------------------------------

_dot-start:
	.dot/script/dot-start

_dot-finish:
	.dot/script/dot-finish
