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

# Create a new CSV with date, id, and language
paste <(echo "$pub_date") <(echo "$ids") <(echo "$languages") | awk 'BEGIN {FS=OFS="\t"} {print $1, $2, $3}' > updates_temp.csv

# Merge with existing CSV file and sort
{
    echo "date,id,language"
    cat ./data-raw/rss-updates.csv
    cat updates_temp.csv
} | sort -u -k2,2 -t ',' > ./data-raw/rss-updates.csv

rm updates_temp.csv
