.SILENT:


# -- Make dot -----------------------------------------------------------------

# A fresh Mac needs root: the install step asks once, before anything runs
.PHONY: dot
dot: override ARGS := --sudo $(ARGS)
dot: _dot-start run setshell _dot-finish


# -- Workflows ----------------------------------------------------------------

.PHONY: run
run: link install


# -- Steps --------------------------------------------------------------------

.PHONY: link
link:
	.dot/dot/scripts/link-git
	.dot/dot/scripts/link

.PHONY: check
check:
	.dot/dot/scripts/link --check

.PHONY: install
install:
	env -i HOME="${HOME}" .dot/dot/scripts/install $(ARGS)

.PHONY: setshell
setshell:
	.dot/dot/scripts/setshell

.PHONY: defaults
defaults:
	.dot/dot/scripts/defaults


# -- Development --------------------------------------------------------------

.PHONY: lint
lint:
	.dot/dot/scripts/lint

.PHONY: test
test:
	for t in .dot/test/*/*; do "$$t" || exit 1; done


# -- Helpers ------------------------------------------------------------------

.PHONY: _dot-start
_dot-start:
	.dot/dot/scripts/dot-start

.PHONY: _dot-finish
_dot-finish:
	.dot/dot/scripts/dot-finish
