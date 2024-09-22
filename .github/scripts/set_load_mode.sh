#!/bin/bash
# Description:
#   Set the LOAD_MODE environment variable based on whether the Oxigraph DB
#   cache exists or not.
#
# Usage:
#   ./.github/scripts/set_load_mode.sh <cache_hit>
#
# Arguments:
#   cache_hit   Boolean indicating if the cache was found.
#
# Environment Variables:
#   LOAD_MODE   Set to 'partial' if the database exists, or 'full' if it does not.

cache_hit=$1

if [[ "$cache_hit" == 'true' ]]; then
  echo "🗄️️ Database found."
  echo "LOAD_MODE=partial" >> $GITHUB_ENV
else
  echo "🏗️ Database not found, creating new."
  mkdir -p oxigraph_db
  echo "LOAD_MODE=full" >> $GITHUB_ENV
fi
