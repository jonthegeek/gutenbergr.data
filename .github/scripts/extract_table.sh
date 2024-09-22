#!/bin/bash
# Description:
#   Defines a function to extract a table from a SPARQL query result and save it
#   as a CSV file.
#
# Usage:
#   source ./.github/scripts/extract_table.sh
#   extract_table <table_name> <query> <entity_column_name>
#
# Arguments:
#   table_name          The name of the table to be used for the output file.
#   query               The SPARQL query to execute.
#   entity_column_name  The name to use for the 'entity' column in the CSV file.
#
# Environment Variables:
#   RUNNER_TEMP   Optional. Temporary directory for storing JSON intermediate
#                 results. Defaults to '/tmp'.

extract_table() {
  local table_name=$1
  local query=$2
  local entity_column_name=$3
  local temp_dir=${RUNNER_TEMP:-/tmp}
  local json_file="${temp_dir}/${table_name}.json"
  local csv_file="./${table_name}.csv"

  # Extract column names from query SELECT.
  local select_line=$(echo "$query" | grep '^SELECT')
  local other_names=$(echo "$select_line" | sed "s/?entity//" | \
    tr -d 'SELECT?' | tr -s ' ' ',' | sed 's/^,//' | sed 's/,$//')
  local column_names="$entity_column_name,$other_names"
  if [ -z "$other_names" ]; then
      echo "Error: Column names could not be extracted."
      exit 1
  fi

  # Dynamically generate the jq expression
  local jq_expression=$(echo "$other_names" | \
    sed "s/,/ /g" | \
    awk '{for (i=1; i<=NF; i++) printf ".%s.value, ", $i; print ""}' | \
    sed 's/, $//')

  # Perform the SPARQL query and save the results as JSON
  curl -G --data-urlencode "query=$query" http://localhost:7878/query -o $json_file

  # Parse JSON to CSV
  if [ -f "$csv_file" ]; then
      rm $csv_file
  fi
  echo "$column_names" > $csv_file
  jq -r ".results.bindings[] | [(.entity.value | split(\"/\") | last), \
    $jq_expression] | @csv" $json_file >> $csv_file

  # Clean up the temporary JSON file
  rm $json_file
}
