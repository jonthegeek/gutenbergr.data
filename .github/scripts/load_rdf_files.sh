#!/bin/bash
# Description:
#   Load a batch of RDF files into an Oxigraph instance.
#
# Usage:
#   ./.github/scripts/load_rdf_files.sh <rdf_dir>
#
# Arguments:
#   rdf_dir   The path to the directory containing RDF files.
#
# Environment Variables:
#   LOAD_MODE     Whether to perform a 'full' load or a 'partial' load.
#   RSS_IDS_FILE  Path to a file with RSS ids to potentially update.

source ./.github/scripts/load_rdf.sh

mode=$LOAD_MODE
rdf_dir=$1

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
  if [ -f "$RSS_IDS_FILE" ]; then
    ids=$(cat "$RSS_IDS_FILE")
    echo "Loaded RSS ids: $ids"
  else
    echo "❗No RSS ids file found."
    exit 1
  fi
  for id in $ids; do
    load_rdf "$rdf_dir" "$id"
  done
fi
