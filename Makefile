.SILENT:


# -- Make dot -----------------------------------------------------------------

.PHONY: dot
dot: _dot-start run setshell _dot-finish


# -- Workflows ----------------------------------------------------------------

.PHONY: run
run: link install

.PHONY: macosrun
macosrun: apps defaults


# -- Steps --------------------------------------------------------------------

.PHONY: link
link:
	.dot/dot/scripts/link-git
	.dot/dot/scripts/link

.PHONY: install
install:
	env -i HOME="${HOME}" .dot/dot/scripts/install-deps-core
	env -i HOME="${HOME}" .dot/dot/scripts/install-deps
	env -i HOME="${HOME}" .dot/dot/scripts/install

.PHONY: setshell
setshell:
	.dot/dot/scripts/setshell

.PHONY: defaults
defaults:
	.dot/dot/scripts/defaults

.PHONY: apps
apps:
	.dot/dot/scripts/apps


# -- Helpers ------------------------------------------------------------------

.PHONY: _dot-start
_dot-start:
	.dot/dot/scripts/dot-start

.PHONY: _dot-finish
_dot-finish:
	.dot/dot/scripts/dot-finish
