#!/bin/bash
# Description:
#   Check if the Oxigraph database directory exists and set the environment
#   variable LOAD_MODE accordingly.
#
# Usage:
#   ./.github/scripts/check_oxigraph_db.sh
#
# Environment Variables:
#   LOAD_MODE   Set to 'partial' if the database exists, or 'full' if it does
#               not.

if [ -d "oxigraph_db" ]; then
  echo "🗄️️ Database found."
  echo "LOAD_MODE=partial" >> $GITHUB_ENV
else
  echo "🏗️ Database not found, creating new."
  mkdir -p oxigraph_db
  echo "LOAD_MODE=full" >> $GITHUB_ENV
fi
