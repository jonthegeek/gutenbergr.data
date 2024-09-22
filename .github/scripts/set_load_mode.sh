#!/bin/bash
# Description:
#   Set the LOAD_MODE environment variable based on whether the Oxigraph DB
#   cache matched key exists or not.
#
# Usage:
#   ./.github/scripts/set_load_mode.sh <cache_matched_key>
#
# Arguments:
#   cache_matched_key   The key matched by the cache restore action.
#
# Environment Variables:
#   LOAD_MODE   Set to 'partial' if the database exists, or 'full' if it does not.

cache_matched_key=$1

if [[ -n "$cache_matched_key" ]]; then
  echo "🗄️️ Database found."
  echo "LOAD_MODE=partial" >> $GITHUB_ENV
else
  echo "🏗️ Database not found, creating new."
  mkdir -p oxigraph_db
  echo "LOAD_MODE=full" >> $GITHUB_ENV
fi
