#------------------------------------------------------------------------------
# InteractiveShellApp(Configurable) configuration
#------------------------------------------------------------------------------

## List of files to run at IPython startup.
c.InteractiveShellApp.exec_files = []

## A list of dotted module names of IPython extensions to load.
c.InteractiveShellApp.extensions = ['autoreload']

## lines of code to run at IPython startup.
c.InteractiveShellApp.exec_lines = [
    '%autoreload 2',
    'import datetime'
]

## Should variables loaded at startup (by startup files, exec_lines, etc.) be
#  hidden from tools like %who?
c.InteractiveShellApp.hide_initial_ns = True

#------------------------------------------------------------------------------
# InteractiveShell(SingletonConfigurable) configuration
#------------------------------------------------------------------------------

## Make IPython automatically call any callable object even if you didn't type
#  explicit parentheses. For example, 'str 43' becomes 'str(43)' automatically.
#  The value can be '0' to disable the feature, '1' for 'smart' autocall, where
#  it is not applied if there are no more arguments on the line, and '2' for
#  'full' autocall, where all callable objects are automatically called (even if
#  no arguments are present).
c.InteractiveShell.autocall = 1

## Autoindent IPython code entered interactively.
c.InteractiveShell.autoindent = True

## Enable magic commands to be called without the leading %.
c.InteractiveShell.automagic = False

## The name of the logfile to use.
# c.InteractiveShell.logfile = '~/Desktop/ipython.log.py'

## Start logging to the default log file in overwrite mode. Use `logappend` to
#  specify a log file to **append** logs to.
c.InteractiveShell.logstart = False

## Automatically call the pdb debugger after every exception.
c.InteractiveShell.pdb = False

#------------------------------------------------------------------------------
# TerminalInteractiveShell(InteractiveShell) configuration
#------------------------------------------------------------------------------

## Set to confirm when you try to exit IPython with an EOF (Control-D in Unix,
#  Control-Z/Enter in Windows). By typing 'exit' or 'quit', you can force a
#  direct exit without any confirmation.
c.TerminalInteractiveShell.confirm_exit = False

## Set the editor used by IPython (default to $EDITOR/vi/notepad).
c.TerminalInteractiveShell.editor = 'vim'

# Automatically set the terminal title
c.TerminalInteractiveShell.term_title = False
