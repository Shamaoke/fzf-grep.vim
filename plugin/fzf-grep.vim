vim9script
##                ##
# ::: Fzf Grep ::: #
##                ##

import 'fzf-run.vim' as Fzf

var spec = {
  'fzf_default_command': $FZF_DEFAULT_COMMAND,

  'fzf_data': ( ) => 'rg --color=ansi --line-number .',

  'fzf_command': (data) => $"{data} || exit 0",

  'tmp_file': ( ) => tempname(),

  'geometry': {
    'width': 0.8,
    'height': 0.8
  },

  'commands': {
    'enter':  (entry) => $"edit +{entry->split(':')->get(1)} {entry->split(':')->get(0)}",
    'ctrl-t': (entry) => $"tabedit +{entry->split(':')->get(1)} {entry->split(':')->get(0)}",
    'ctrl-s': (entry) => $"split +{entry->split(':')->get(1)} {entry->split(':')->get(0)}",
    'ctrl-v': (entry) => $"vsplit +{entry->split(':')->get(1)} {entry->split(':')->get(0)}"
  },

  'term_command': [
    'fzf',
    '--no-multi',
    '--delimiter=:',
    '--preview-window=border-left:+{2}-/2',
    '--preview=bat --color=always --style=numbers --highlight-line={2} {1}',
    '--nth=1,3',
    '--ansi',
    '--expect=enter,ctrl-t,ctrl-s,ctrl-v'
  ],

  'term_options': {
    'hidden': true,
    'out_io': 'file'
  },

  'popup_options': {
    'title': '─ ::: Fzf Grep ::: ─',
    'border': [1, 1, 1, 1],
    'borderchars': ['─', '│', '─', '│', '┌', '┐', '┘', '└']
  }
}

command DvFzfGR Fzf.Run()

# vim: set textwidth=80 colorcolumn=80:
