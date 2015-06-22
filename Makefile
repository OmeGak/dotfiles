.SILENT:
.PHONY: dot
.PHONY: bootstrap ossetup
.PHONY: zeroday link install defaults apps
.PHONY: _dot-start _dot-finish


# -- Make dot -----------------------------------------------------------------

dot: _dot-start zeroday bootstrap _dot-finish


# -- Workflows ----------------------------------------------------------------

bootstrap: link install
osxsetup: apps install defaults


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
