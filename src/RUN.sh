#!/usr/bin/bash
#===============================================================================
# File:         RUN.sh
# Description:  Simple wrapper to run the main application
#===============================================================================

cd "$(dirname "$0")"
exec bash main.sh "$@"

