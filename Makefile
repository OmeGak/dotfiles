.SILENT:


# -- Make dot -----------------------------------------------------------------

# A fresh clone: everything else is a step of `dot`
.PHONY: dot
dot:
	.dot/bin/dot setup


# -- Development --------------------------------------------------------------

.PHONY: lint
lint:
	.dot/dot/scripts/lint

.PHONY: test
test:
	for t in .dot/test/*/*; do "$$t" || exit 1; done
