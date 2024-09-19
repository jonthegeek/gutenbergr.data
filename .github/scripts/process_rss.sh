#!/bin/bash

url="https://www.gutenberg.org/cache/epub/feeds/today.rss"
rss_content=$(curl -s "$url")

# Extract publication date, ids, and languages
pub_date=$(echo "$rss_content" | xmllint --xpath 'string(//rss/channel/pubDate)' - | date -d - +"%Y-%m-%d")
ids=$(echo "$rss_content" | xmllint --xpath '//rss/channel/item/link/text()' - | grep -o '[0-9]*$')
languages=$(echo "$rss_content" | xmllint --xpath '//rss/channel/item/description/text()' - | sed 's/^Language: //g' | tr '[:upper:]' '[:lower:]')

# Combine extracted data into a temporary file
paste <(echo "$pub_date") <(echo "$ids") <(echo "$languages") > updates_temp.csv

# Merge the new data with the existing CSV file
{
    echo "date,id,language"
    cat ./data-raw/rss-updates.csv
    cat updates_temp.csv
# Use awk to keep only the first occurrence of each id
} | awk -F, '!seen[$2]++' > ./data-raw/rss-updates.csv

# Clean up the temporary file
rm updates_temp.csv
