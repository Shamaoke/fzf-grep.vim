vim9script
##                ##
# ::: Fzf Grep ::: #
##                ##

import 'fzf-run.vim' as Fzf

var spec = {
  'set_fzf_data': (data) =>
    systemlist('rg --color=ansi --line-number . 2>/dev/null')
      ->writefile(data),

  'set_tmp_file': ( ) => tempname(),
  'set_tmp_data': ( ) => tempname(),

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
    '--nth=3..',
    '--ansi',
    '--bind=ctrl-h:first,ctrl-e:last,alt-h:preview-top,alt-e:preview-bottom,alt-j:preview-down,alt-k:preview-up,alt-p:toggle-preview,alt-x:change-preview-window(right,90%|right,50%)',
    '--expect=enter,ctrl-t,ctrl-s,ctrl-v'
  ],

  'set_term_command_options': (data) =>
    [ $"--bind=start:reload^cat '{data}'^" ],

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

command FzfGR Fzf.Run(spec)

# vim: set textwidth=80 colorcolumn=80:
