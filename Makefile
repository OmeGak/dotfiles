.SILENT:
.PHONY: bootstrap ossetup all
.PHONY: zeroday link install defaults apps
.PHONY: link-deps install-deps defaults-deps apps-deps


# -- Workflows ----------------------------------------------------------------

bootstrap: link install
ossetup: apps install defaults
all: zeroday bootstrap defaults ossetup


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

apps: apps-deps
	.dot/apps


# -- Dependencies -------------------------------------------------------------

link-deps:
	.dot/link-deps

install-deps:
	.dot/install-deps

defaults-deps:
	.dot/defaults-deps

apps-deps:
	.dot/apps-deps
