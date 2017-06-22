# OmeGak (also) does dotfiles

```
   ██████   ██████  ████████ ███████ ██ ██      ███████ ███████
   ██   ██ ██    ██    ██    ██      ██ ██      ██      ██
   ██   ██ ██    ██    ██    █████   ██ ██      █████   ███████
   ██   ██ ██    ██    ██    ██      ██ ██      ██           ██
██ ██████   ██████     ██    ██      ██ ███████ ███████ ███████
                                              Let's do(t) this!
```


Your dotfiles are how you personalize your system. These are mine.

This framework was forked from [Zach Holman](https://github.com/holman)'s
[dotfiles](https://github.com/holman/dotfiles) and based on his ideas:

> I was a little tired of having long alias files and everything strewn about
> (which is extremely common on other dotfiles projects, too). That led to this
> project being much more topic-centric. I realized I could split a lot of
> things up into the main areas I used (Ruby, git, system libraries, and so
> on), so I structured the project accordingly.
>
> If you're interested in the philosophy behind why projects like these are
> awesome, you might want to [read my post on the
> subject](http://zachholman.com/2010/08/dotfiles-are-meant-to-be-forked/).


## install

Easy. Run this:

```bash
git clone --recursive https://github.com/omegak/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make
```

The installation process will guide you through and will mainly: 1) set your
shell to `zsh`, 2) symlink the appropriate files in `.dotfiles` to your home
directory, and 3) run several install scripts.

Everything is configured and tweaked within `~/.dotfiles`. The main file
you'll want to change right off the bat is `zsh/zshrc.symlink`, which sets up a
few paths that'll be different on your particular machine.


## usage

After the install, do things with `dot`. It's a fairly simple script that
gives access to some common actions.

* `dot run` will symlink new files into your home directory and run topic
  installers.
* `dot macosrun` will install OS X applications and apply setting defaults.
* `dot edit` will open an editor on your `~/.dotfiles` folder.


## customization

My dotfiles come with a lot of stuff. Seriously, a lot of stuff. Check them out
in the file browser above and see what components may mess up with you.
[Fork it](https://github.com/omegak/dotfiles/fork), remove what you don't use,
and build on what you do use.

### topical

Everything's built around topic areas. If you're adding a new area to your
forked dotfiles — say, "Java" — you can simply add a `java` directory and put
files in there. Anything with an extension of `.zsh` will get automatically
included into your shell. Anything with an extension of `.symlink` will get
symlinked without extension into `$HOME` when you do `dot run`.

### components

There's a few special files in the hierarchy.

- **bin/**: Anything in `bin/` will get added to your `$PATH` and be made
  available everywhere.
- ***topic*/\*.zsh**: Any files ending in `.zsh` get loaded into your
  environment.
- ***topic*/path.zsh**: Any file named `path.zsh` is loaded first and is
  expected to setup `$PATH` or similar.
- ***topic*/completion.zsh**: Any file named `completion.zsh` is loaded
  last and is expected to setup autocomplete.
- ***topic*/\*.symlink**: Any files ending in `*.symlink` get symlinked into
  your `$HOME`. This is so you can keep all of those versioned in your dotfiles
  but still keep those autoloaded files in your home directory. New files will
  get symlinked with `dot run`.
- ***topic*/\*.install.sh**: These scripts will be run during the initial
  installation and anytime after that with `dot run`. They are expected to
  install stuff in the system.
- ***topic*/\*.install.dep.sh**: These scripts will be executed before the
  `*.install.sh` ones do. They are expected to install stuff the latter depend
  on.


## bugs

I want this to work for everyone; that means when you clone it down it should
work for you even though you may not have `rbenv` installed, for example. That
said, I do use this as *my* dotfiles, so there's a good chance I may break
something if I forget to make a check for a dependency.

If you're brand-new to the project and run into any blockers, please
[open an issue](https://github.com/omegak/dotfiles/issues) on this repository
and I'd love to get it fixed for you!


## thanks

I first learned of dotfiles frameworks from
[dotfiles.github.io](http://dotfiles.github.io/).

I forked [Zach Holman](https://github.com/holman)'s minimalistic
[framework](https://github.com/holman/dotfiles) and kept on tweaking it until my
changes were too big to keep up with upstream and decided to maintain my own.
Holman's dotfiles were an easy way to get into shell customization and system
automation and a decent amount of the code in these dotfiles stems or is
inspired from his original project.
