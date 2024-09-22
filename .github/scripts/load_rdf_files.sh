#!/bin/bash
# Description:
#   Load a batch of RDF files into an Oxigraph instance.
#
# Usage:
#   ./.github/scripts/load_rdf_files.sh <mode> <rdf_dir>
#
# Arguments:
#   mode      Whether to perform a 'full' load or a 'partial' load.
#   rdf_dir   The path to the directory containing RDF files.

source ./.github/scripts/load_rdf.sh

mode=$1
rdf_dir=$2

if [ "$mode" == "full" ]; then
  i=0
  for id in $(ls "$rdf_dir"); do
    load_rdf "$rdf_dir" "$id"
    i=$((i+1))
    if [ $((i % 1000)) -eq 0 ]; then
      echo "🕒 [$(date '+%H:%M')] Processed $i files."
    fi
  done
elif [ "$mode" == "partial" ]; then
  rss_url="https://www.gutenberg.org/cache/epub/feeds/today.rss"
  ids=$(curl -s "$rss_url" | grep -oP '(?<=<link>https://www.gutenberg.org/ebooks/)\d+')
  for id in $ids; do
    load_rdf "$rdf_dir" "$id"
  done
fi
