.SILENT:
.PHONY: all bootstrap
.PHONY: zeroday link install defaults
.PHONY: link-deps install-deps defaults-deps


# -- Workflows ----------------------------------------------------------------

bootstrap: link install
all: zeroday link install defaults


# -- Steps --------------------------------------------------------------------

# Things you want to run only the first time you setup your computer
zeroday:
	.dot/zeroday

link: link-deps
	.dot/link

install: install-deps
	.dot/install

defaults: defaults-deps
	.dot/defaults


# -- Dependencies -------------------------------------------------------------

link-deps:
	.dot/link-deps

install-deps:
	.dot/install-deps

defaults-deps:
	.dot/defaults-deps
