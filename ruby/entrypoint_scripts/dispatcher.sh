#!/bin/bash
set -e

BASE_COMMAND=$(echo "$@" | awk -F'-- ' '{print $2}' )
for arg in "$@"
do
  if [[ "$arg" == "--" ]]; then
    shift
    break
  elif [[ -f $arg ]]; then
    $arg
    shift
  else
    "/opt/entrypoint/$arg.sh" $BASE_COMMAND
    shift
  fi
done

exec "$@"
