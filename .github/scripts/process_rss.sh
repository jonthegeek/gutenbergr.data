#!/bin/bash

url="https://www.gutenberg.org/cache/epub/feeds/today.rss"
rss_content=$(curl -s "$url")

# Extract publication date of the overall feed.
pub_date=$(echo "$rss_content" | xmllint --xpath 'string(//rss/channel/pubDate)' - | xargs -I{} date -d "{}" +"%Y-%m-%d")

# Extract IDs from the end of the link.
ids=$(echo "$rss_content" | xmllint --xpath '//rss/channel/item/link/text()' - | grep -o '[0-9]*$')

# Extract and clean languages from the description.
languages=$(echo "$rss_content" | xmllint --xpath '//rss/channel/item/description/text()' - | sed 's/^Language: //g' | tr '[:upper:]' '[:lower:]')

# Make sure we have the same number of IDs and languages.
if [ $(echo "$ids" | wc -l) -ne $(echo "$languages" | wc -l) ]; then
    echo "Error: Number of IDs and languages do not match."
    exit 1
fi

# Merge the new updates with the existing CSV file and sort, ensuring the header stays at the top
{
    echo "date,id,language"
    tail -n +2 ./data-raw/rss-updates.csv  # Exclude the existing header
    cat updates_temp.csv
} | sort -u -k2,2 -t ',' | awk '!seen[$2]++' > ./data-raw/rss-updates_temp.csv

# Move the sorted file to the correct location
mv ./data-raw/rss-updates_temp.csv ./data-raw/rss-updates.csv

# Clean up
rm updates_temp.csv
