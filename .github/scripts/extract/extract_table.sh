#!/bin/bash
# Description:
#   Defines a function to extract a table from a SPARQL query result and save it
#   as a CSV file.
#
# Usage:
#   source ./.github/scripts/extract_table.sh
#   extract_table <table_name> <query>
#
# Arguments:
#   table_name          The name of the table to be used for the output file.
#   query               The SPARQL query to execute.
#
# Environment Variables:
#   RUNNER_TEMP   Optional. Temporary directory for storing JSON intermediate
#                 results. Defaults to '/tmp'.

extract_table() {
  local table_name=$1
  local query=$2
  local temp_dir=${RUNNER_TEMP:-/tmp}
  local json_file="${temp_dir}/${table_name}.json"
  local csv_file="./${table_name}.csv"

  # Perform the SPARQL query and save the results as JSON
  curl -G --data-urlencode "query=$query" http://localhost:7878/query -o $json_file

  # Parse JSON to CSV
  if [ -f "$csv_file" ]; then
      rm $csv_file
  fi
  jq -r '.head.vars | @csv' $json_file > $csv_file
  jq -r '.results.bindings[] | [.[]?.value] | @csv' $json_file >> $csv_file

  # Clean up the temporary JSON file
  rm $json_file
}
