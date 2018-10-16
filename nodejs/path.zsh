# Allows running `npm` packages installed globally without `sudo`
# Source: https://github.com/sindresorhus/guides/blob/master/npm-global-without-sudo.md

NPM_PACKAGES="${HOME}/.npm-packages"
PATH="${NPM_PACKAGES}/bin:${PATH}"
MANPATH="${NPM_PACKAGES}/share/man:${MANPATH}"
