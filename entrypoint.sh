#!/bin/bash

set -e  # Exit on any error
set -x  # Print commands and their arguments as they are executed

CMD=$@

# By default run a development server.
if [ "$CMD" == "" ]; then
    CMD="develop"
fi

if ! [[ "$CMD" =~ ^(install|develop|clean|build|serve)$ ]]; then
    echo "Valid commands are: install, develop, clean, build, serve."
    exit 1
fi

case "$CMD" in
  install)
    OPTIONS=""
    ;;
  develop)
    OPTIONS="-H 0.0.0.0"
    ;;
  build)
    OPTIONS=""
    ;;
  serve)
    OPTIONS="-H 0.0.0.0"
    ;;
esac

# Install dependencies.
if [ "$CMD" != "serve" ]; then
    echo "Installing dependencies..."
    yarn install
fi

# Serve site.
if [ "$CMD" != "install" ]; then
    echo "Running Gatsby command: gatsby $CMD $OPTIONS"
    gatsby $CMD $OPTIONS
fi

