# setup geometry plugins

PROMPT_GEOMETRY_GIT_CONFLICTS=true
PROMPT_GEOMETRY_GIT_TIME=false
GEOMETRY_COLOR_EXIT_VALUE="35"              # prompt symbol color when exit value is != 0
GEOMETRY_COLOR_PROMPT="white"               # prompt symbol color
GEOMETRY_COLOR_ROOT="31"                    # root prompt symbol color
GEOMETRY_COLOR_DIR="4"                      # current directory color
GEOMETRY_PLUGIN_SEPARATOR=":"               # use ' ' to separate right prompt parts
GEOMETRY_GIT_SEPARATOR=$GEOMETRY_PLUGIN_SEPARATOR
GEOMETRY_PROMPT_PLUGINS=(exec_time jobs git)

# fix function to use builtin cd function
-geometry-async-prompt() {
  # In order to work with zsh-async we need to set workers in
  # the proper directory.
  builtin cd -q $1 > /dev/null
  prompt_geometry_render_rprompt
}
