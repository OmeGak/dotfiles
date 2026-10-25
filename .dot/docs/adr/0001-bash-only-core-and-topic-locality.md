# A bash-only core, and every topic owns its own files

The core under `.dot/` runs on a fresh Mac or Linux box before anything is
installed, so it depends on nothing beyond bash, the system tools and what
Homebrew itself needs: no Python, no Ruby, no dotfile manager. Each topic
holds everything about itself (its links, installers and shell files), so
there is no central manifest to keep in step with the topics.

## Considered options

- **dotbot**: the closest fit for manifest-driven linking, rejected because
  it is Python and reads one config file for the whole repo.
- **GNU Stow**: Perl, which macOS ships, and one package per topic, rejected
  because a topic mixes scripts with linkable files, so every topic would
  need a `home/` subtree or an ignore list, and Stow refuses on conflict
  rather than backing up.
- **chezmoi**: a whole framework in Go, rejected as a second migration on
  top of the planned move to Nix.
