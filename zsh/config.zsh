fpath=($DOT/functions $fpath)

autoload -U $DOT/functions/*(:t)


# -- Changing directories -----------------------------------------------------

setopt   AUTO_PUSHD         # Track history of directories for navigation
setopt   PUSHD_IGNORE_DUPS  # Keep dir stack clean of dupes
setopt   PUSHD_MINUS        # Make popd/pushd go back # dirs on `-#` instead of `+#`
setopt   PUSHD_SILENT       # Otherwise popd prints the cd'd directory
unsetopt PUSHD_TO_HOME      # Ensure pushd swaps to most current dir and not $HOME


# -- Completion ---------------------------------------------------------------

# Completion behavior I like
setopt   AUTO_LIST
setopt   AUTO_MENU

unsetopt AUTO_NAME_DIRS    # Disable named dirs (ASDF=`pwd` would show ~ASDF in prompt)
setopt   COMPLETE_ALIASES  # Don't expand aliases _before_ completion has finished (like: git comm-<TAB>)
setopt   GLOB_COMPLETE     # Show menu with options matching pattern (like: cd D*s<TAB>)
unsetopt LIST_BEEP         # Shhh


# -- Globbing ---------------------------------------------------

setopt   EXTENDED_GLOB      # Enable nice globbing features (watch out! It doesn't play well with git)
setopt   MARK_DIRS          # Append a trailing '/' to all directory names resulting from globbing
setopt   NUMERIC_GLOB_SORT  # Sort glob results numerically rather than lexically
# TODO: reenable once zplug output is fixed
# setopt   RC_EXPAND_PARAM    # Enable `foo${xx}bar`-like globbing for generating variations


# -- History ------------------------------------------------------------------

HISTFILE=~/.zhistory
HISTSIZE=10000
SAVEHIST=$HISTSIZE

setopt   EXTENDED_HISTORY      # Add command line timestamps to history
unsetopt HIST_BEEP             # Shhh
setopt   HIST_FCNTL_LOCK       # Prevent history corruption
setopt   HIST_IGNORE_ALL_DUPS  # Keep history clean from dupes
setopt   HIST_IGNORE_SPACE     # Do not record command lines starting with space
setopt   HIST_NO_FUNCTIONS     # Do not record function definitions
setopt   HIST_REDUCE_BLANKS    # Remove superfluous blanks from each command line
setopt   HIST_SAVE_NO_DUPS     # Ensure no dupes when writing out to history file
setopt   HIST_VERIFY           # Do not execute lines directly on history expansion
setopt   INC_APPEND_HISTORY    # Write to $HISTFILE immediately


# -- I/O ----------------------------------------------------------------------

# Do not suggest private functions on correction
CORRECT_IGNORE='_*'

setopt   CORRECT               # Try to correct spelling of commands
unsetopt FLOW_CONTROL          # Disable XON/XOFF (<C-S>/<C-Q> to stop/start tty)
setopt   IGNORE_EOF            # Do not exit shell on <C-D>
setopt   INTERACTIVE_COMMENTS  # Allow comments in interactive shell


# -- Job control --------------------------------------------------------------

unsetopt BG_NICE         # Do not give low priority to background jobs
unsetopt HUP             # Do not send HUP signal on shell exit
setopt   LONG_LIST_JOBS  # List jobs in the long format by default


# -- Prompt -------------------------------------------------------------------

setopt   PROMPT_SUBST   # Enable command substitution in the prompt


# -- Scripts ------------------------------------------------------------------

setopt   C_BASES        # Output hexadecimal numbers as 0xFF i.e. `$(( [#16]255 ))`
# TODO: reenable once zplug output is fixed
# setopt   LOCAL_OPTIONS  # Restore changed zsh options on function return
setopt   LOCAL_TRAPS    # Restore changed trap values on function return


# -- ZLE ----------------------------------------------------------------------

setopt   EMACS  # Set Emacs mode
