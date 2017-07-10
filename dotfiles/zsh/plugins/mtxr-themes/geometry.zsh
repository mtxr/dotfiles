# setup geometry plugins

PROMPT_GEOMETRY_GIT_CONFLICTS=true
PROMPT_GEOMETRY_GIT_TIME=false
GEOMETRY_GIT_SEPARATOR=""

GEOMETRY_SYMBOL_PROMPT="▲"                  # default prompt symbol
GEOMETRY_SYMBOL_RPROMPT="◇"                 # multiline prompts
GEOMETRY_SYMBOL_EXIT_VALUE="△"              # displayed when exit value is != 0
GEOMETRY_SYMBOL_ROOT="▲"                    # when logged in user is root
GEOMETRY_COLOR_EXIT_VALUE="magenta"         # prompt symbol color when exit value is != 0
GEOMETRY_COLOR_PROMPT="white"               # prompt symbol color
GEOMETRY_COLOR_ROOT="red"                   # root prompt symbol color
GEOMETRY_COLOR_DIR="blue"                   # current directory color
GEOMETRY_PROMPT_SUFFIX=""                   # suffix prompt
GEOMETRY_PLUGIN_SEPARATOR=":"               # use ' ' to separate right prompt parts
GEOMETRY_GREP=""                            # define which grep-like tool to use (By default it looks for rg, ag and finally grep)
GEOMETRY_PROMPT_PLUGINS=(exec_time jobs git)
. $HOME/.workstation/dotfiles/zsh/plugins/geometry-theme/geometry.zsh

# fix function to use builtin cd function
-geometry-async-prompt() {
  # In order to work with zsh-async we need to set workers in
  # the proper directory.
  builtin cd -q $1 > /dev/null
  prompt_geometry_render_rprompt
}
