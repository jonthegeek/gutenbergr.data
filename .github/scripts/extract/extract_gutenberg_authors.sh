#!/bin/bash
# Description:
#   Extract author data from the Project Gutenberg RDF graph and store it in
#   'gutenberg_authors.csv'.
#
# Usage:
#   ./.github/scripts/extract_gutenberg_authors.sh

source ./.github/scripts/extract/extract_table.sh

table_name="gutenberg_authors"
query="PREFIX pgterms: <http://www.gutenberg.org/2009/pgterms/>
SELECT ?gutenberg_author_id ?author ?birthdate ?deathdate
WHERE {
  GRAPH <http://gutenberg.org/graph/catalog> {
    ?entity a pgterms:agent .
    ?entity pgterms:name ?author .
    OPTIONAL { ?entity pgterms:birthdate ?birthdate } .
    OPTIONAL { ?entity pgterms:deathdate ?deathdate } .
    BIND(STRAFTER(STR(?entity), '/agents/') AS ?gutenberg_author_id)
  }
}"

extract_table "$table_name" "$query"
