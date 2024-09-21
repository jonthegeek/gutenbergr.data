#!/bin/bash

# Source the extract_table function
source ./.github/scripts/extract_table.sh

# Define variables specific to the gutenberg_authors table
table_name="gutenberg_authors"
query="PREFIX pgterms: <http://www.gutenberg.org/2009/pgterms/>
SELECT ?entity ?author ?birthdate ?deathdate
WHERE {
  GRAPH <http://gutenberg.org/graph/catalog> {
    ?entity a pgterms:agent .
    ?entity pgterms:name ?author .
    OPTIONAL { ?entity pgterms:birthdate ?birthdate } .
    OPTIONAL { ?entity pgterms:deathdate ?deathdate } .
  }
}"

# Call the extract_table function with the appropriate arguments
extract_table "$table_name" "$query" "gutenberg_author_id"

