#!/bin/bash
# Description:
#   Check for updates in the Project Gutenberg RSS feed, and update the
#   environment variable LOAD_MODE if necessary.
#
# Usage:
#   ./.github/scripts/check_rss.sh
#
# Environment Variables:
#   LOAD_MODE     Set to 'none' if no updates are found.
#   RSS_PUBDATE   The pubDate of the RSS file.
#   RSS_IDS_FILE  Path to a file with RSS ids to potentially update.

rss_content=$(curl -s "https://www.gutenberg.org/cache/epub/feeds/today.rss")

if [ -z "$rss_content" ]; then
  echo "❗Failed to fetch RSS content."
  exit 1
fi

rss_pubdate=$(echo "$rss_content" | grep -oP '(?<=<pubDate>).*?(?=</pubDate>)')
if [ -z "$rss_pubdate" ]; then
  echo "❗Failed to extract pubDate."
  exit 1
fi
# Process the pubDate to remove spaces, commas, and colons
simplified_pubdate=$(echo "$rss_pubdate" | sed 's/[ ,:]//g')
echo "Processed RSS pubDate: $simplified_pubdate"
echo "RSS_PUBDATE=$simplified_pubdate" >> "$GITHUB_ENV"

ids=$(echo "$rss_content" | grep -oP '(?<=<link>https://www.gutenberg.org/ebooks/)\d+')

if [ -z "$ids" ]; then
  echo "📭 No RSS updates found."
  echo "LOAD_MODE=none" >> "$GITHUB_ENV"
else
  echo "📰 RSS updates found, will check cached RSS."

  temp_dir=${RUNNER_TEMP:-/tmp}
  echo "$ids" > "$temp_dir/rss_ids.txt"
  echo "RSS_IDS_FILE=$temp_dir/rss_ids.txt" >> "$GITHUB_ENV"
fi
