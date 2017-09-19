#!/bin/bash
#
# Bash completion support for Fabric (http://fabfile.org/)
#
# Copyright (C) 2011 by Konstantin Bakulin
#
# Thanks to:
# - Adam Vandenberg,
#   https://github.com/adamv/dotfiles/blob/master/completion_scripts/fab_completion.bash
#
# - Enrico Batista da Luz,
#   https://github.com/ricobl/dotfiles/blob/master/bin/fab_bash_completion
#
# Refactored by:
#  - Sergei Gerasenko

# If set to "false", "fab --shortlist" will be executed every time.
export USE_CACHE=true

export RECIPIES_DIR=~/proj/misc/fabfiles

# File name where tasks cache will be stored (in current dir).
export CACHED_TASKS_FILE=".fab_tasks~"

# Set command to get time of last file modification as seconds since Epoch
case `uname` in
  Darwin|FreeBSD)
    __MTIME_COMMAND="stat -f '%m'"
    ;;
  *)
    __MTIME_COMMAND="stat -c '%Y'"
    ;;
esac

#
# Get time of last fab cache file modification as seconds since Epoch
#
function __fab_chache_mtime() {
  ${__MTIME_COMMAND} $CACHED_TASKS_FILE | xargs -n 1 expr
}

#
# Get time of last fabfile file/module modification as seconds since Epoch
#
function __fab_fabfile_mtime() {
  if [[ $PWD != $RECIPIES_DIR ]]; then
    cd $RECIPIES_DIR
  fi
  local f="fabfile"
  if [[ -e "$f.py" ]]; then
    ${__MTIME_COMMAND} "$f.py" | xargs -n 1 expr
  else
    # Assume it's a fabfile dir
    find $f/*.py -exec ${__MTIME_COMMAND} {} + \
      | xargs -n 1 expr | sort -n -r | head -1
  fi
}

function get_fab_opts() {
  if [[ $PWD != $RECIPIES_DIR ]]; then
    cd $RECIPIES_DIR
  fi

  if [[ -z "${__FAB_COMPLETION_LONG_OPT}" ]]; then
    opts=$(fab --help | egrep -o "\-\-[A-Za-z_\-]+\=?" | sort -u)
  fi
  export __FAB_COMPLETION_LONG_OPT=1
  echo $opts
}

function get_fab_tasks() {
  if [[ $PWD != $RECIPIES_DIR ]]; then
    cd $RECIPIES_DIR
  fi

  # If "fabfile.py" or "fabfile" dir with "__init__.py" file exists
  local f="fabfile"
  if [[ -e "$f.py" || (-d "$f" && -e "$f/__init__.py") ]]; then
    # Build a list of the available tasks
    if $USE_CACHE; then
      local refresh_cache=0

      if [[ ! -s ${CACHED_TASKS_FILE} ]]; then
        refresh_cache=1
      fi

      if [[ $(__fab_fabfile_mtime) -gt $(__fab_chache_mtime) ]]; then
        refresh_cache=1
      fi

      if [[ $refresh_cache == 1 ]]; then
        fab --shortlist >| ${CACHED_TASKS_FILE} 2> /dev/null
      fi

      opts=$(cat ${CACHED_TASKS_FILE})
    else
      # Without cache
      opts=$(fab --shortlist 2> /dev/null)
    fi
  fi

  echo $opts
}

function __cnvr_fab_completion() {
  # Variables to hold the current word and possible matches
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local opts=()

  # Generate possible matches and store them in variable "opts"
  case "${cur}" in
    -*)
      opts=$(get_fab_opts)
      ;;
    *)
      opts=$(get_fab_tasks)
      ;;
  esac

  # Set possible completions
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}

complete -o default -o nospace -F __cnvr_fab_completion cnvr-fab
