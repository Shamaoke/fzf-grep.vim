vim9script
##                ##
# ::: Fzf Grep ::: #
##                ##

var config = {
  'command': [
    'fzf',
    '--no-multi',
    '--delimiter=:',
    '--preview-window=border-left:+{2}-/2',
    '--preview=bat --color=always --style=numbers --highlight-line={2} {1}',
    '--nth=3',
    '--ansi',
    '--expect=esc,enter,ctrl-t,ctrl-s,ctrl-v'
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

def SetExitCb( ): func(job, number): string

  def Callback(job: job, status: number): string
    var commands: list<string>

    commands = ['quit']

    return execute(commands)
  enddef

  return Callback

enddef

def SetCloseCb(file: string): func(channel): string

  def Callback(channel: channel): string
    var data: list<string> = readfile(file)

    if data->len() < 2
      return execute([':$bwipeout', ':', $"call delete('{file}')"])
    endif

    var key   = data->get(0)
    var value = data->get(-1)

    var [path, line; _] = value->split(':')

    var commands: list<string>

    if key == 'enter'
      commands = [':$bwipeout', $"edit +{line} {path}", $"call delete('{file}')"]
    elseif key == 'ctrl-t'
      commands = [':$bwipeout', $"tabedit +{line} {path}", $"call delete('{file}')"]
    elseif key == 'ctrl-s'
      commands = [':$bwipeoput', $"split +{line} {path}", $"call delete('{file}')"]
    elseif key == 'ctrl-v'
      commands = [':$bwipeoput', $"vsplit +{line} {path}", $"call delete('{file}')"]
    else
      commands = [':$bwipeout', ':', $"call delete('{file}')"]
    endif

    return execute(commands)
  enddef

  return Callback

enddef

def ExtendCommandOptions(options: list<string>): list<string>
  var extensions = [ ]

  return options->extendnew(extensions)
enddef

def ExtendTermOptions(options: dict<any>): dict<any>
  var tmp_file = tempname()

  var extensions =
    { 'out_name': tmp_file,
      'exit_cb':  SetExitCb(),
      'close_cb': SetCloseCb(tmp_file) }

  return options->extendnew(extensions)
enddef

def ExtendPopupOptions(options: dict<any>): dict<any>
  var extensions =
    { minwidth:  (&columns * 0.8)->ceil()->float2nr(),
      minheight: (&lines * 0.8)->ceil()->float2nr() }

  return options->extendnew(extensions)
enddef

def FzfGR( ): void

  var fzf_previous_default_command = $FZF_DEFAULT_COMMAND

  $FZF_DEFAULT_COMMAND = 'rg --color=ansi --line-number . || exit 0'

  try
    term_start(
      config
        ->get('command')
        ->ExtendCommandOptions(),
      config
        ->get('term_options')
        ->ExtendTermOptions())
      ->popup_create(
          config
            ->get('popup_options')
            ->ExtendPopupOptions())
  finally
    $FZF_DEFAULT_COMMAND = fzf_previous_default_command
  endtry

enddef

command FzfGR FzfGR()

# vim: set textwidth=80 colorcolumn=80:
