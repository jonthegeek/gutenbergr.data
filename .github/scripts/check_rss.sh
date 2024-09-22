#!/bin/bash
# Description:
#   Check for updates in the Project Gutenberg RSS feed, and update the
#   environment variable LOAD_MODE if necessary.
#
# Usage:
#   ./.github/scripts/check_rss.sh
#
# Environment Variables:
#   LOAD_MODE   Set to 'none' if no updates are found.

ids=$(curl -s "https://www.gutenberg.org/cache/epub/feeds/today.rss" | \
  grep -oP '(?<=<link>https://www.gutenberg.org/ebooks/)\d+')

if [ -z "$ids" ]; then
  echo "📭 No RSS updates found."
  echo "LOAD_MODE=none" >> "$GITHUB_ENV"
else
  echo "📰 RSS updates found."
fi
