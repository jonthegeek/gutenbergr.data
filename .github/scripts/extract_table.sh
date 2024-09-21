#!/bin/bash

# Function to extract a table from the SPARQL query result and save it as CSV
extract_table() {
  local table_name=$1
  local query=$2
  local entity_column_name=$3

  # Set file paths based on table name
  local temp_dir=${RUNNER_TEMP:-/tmp}
  local json_file="${temp_dir}/${table_name}.json"
  local csv_file="./data-raw/${table_name}.csv"

  # Extract the line starting with SELECT
  local select_line=$(echo "$query" | grep '^SELECT')

  # Separate entity and other column names
  local other_names=$(echo "$select_line" | sed "s/?entity//" | tr -d 'SELECT?' | tr -s ' ' ',' | sed 's/^,//' | sed 's/,$//')

  # Combine entity_column_name with other_names
  local column_names="$entity_column_name,$other_names"

  # Check if column names were extracted correctly
  if [ -z "$other_names" ]; then
      echo "Error: Column names could not be extracted."
      exit 1
  fi

  # Dynamically generate the jq expression based on column names (no $ symbols)
  local jq_expression=$(echo "$other_names" | sed "s/,/ /g" | awk '{for (i=1; i<=NF; i++) printf ".%s.value, ", $i; print ""}' | sed 's/, $//')

  # Perform the SPARQL query and save the results as JSON
  curl -G --data-urlencode "query=$query" http://localhost:7878/query -o $json_file

  # Remove the CSV file if it already exists
  if [ -f "$csv_file" ]; then
      rm $csv_file
  fi

  # Add headers and parse JSON to CSV
  echo "$column_names" > $csv_file
  jq -r ".results.bindings[] | [(.entity.value | split(\"/\") | last), $jq_expression] | @csv" $json_file >> $csv_file

  # Clean up the temporary JSON file
  rm $json_file
}

