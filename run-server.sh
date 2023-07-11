#!/bin/bash

# We assume a working directory of /app, but that shouldn't matter because we will try to use absolute paths as much as possible

# ENV XDG_DATA_HOME and XDG_CONFIG_HOME are defaulted in Dockerfile
# ENV LOAD_TYPE and LOAD_FROM should also be available here
# $@ contains arguments we should pass to /usr/games/openttd

arguments=("$@")
case "$LOAD_TYPE" in
  'none')
    printf "Will not specify a game\n"
  ;;
  'file')
    arguments+=(-g "$LOAD_FROM")
  ;;
  'directory')
    if [ -z "$LOAD_FROM" ]; then
      printf "You must specify LOAD_FROM for a LOAD_TYPE of directory!\n"
      exit 1
    fi
    save_file=$(find "$LOAD_FROM" -maxdepth 1 -type f 2>/dev/null | xargs --no-run-if-empty ls -t1 | head -n1)

    if [ ! -f "$save_file" ]; then
      printf "Save file does not exist! save_file: $save_file\n"
      exit 1
    fi
    printf "Using save file: $save_file\n"
    arguments+=(-g "$save_file")
  ;;
  'recursive')
    if [ -z "$LOAD_FROM" ]; then
      printf "You must specify LOAD_FROM for a LOAD_TYPE of directory!\n"
      exit 1
    fi
    save_file=$(find "$LOAD_FROM" -type f 2>/dev/null | xargs --no-run-if-empty ls -t1 | head -n1)

    if [ ! -f "$save_file" ]; then
      printf "Save file does not exist! save_file: $save_file\n"
      exit 1
    fi
    printf "Using save file: $save_file\n"
    arguments+=(-g "$save_file")
  ;;
esac

/opt/openttd/openttd "${arguments[@]}"
