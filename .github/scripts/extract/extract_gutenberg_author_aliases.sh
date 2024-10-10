#!/bin/bash
# Description:
#   Extract ebook author aliases from the Project Gutenberg RDF graph and store
#   them in 'gutenberg_author_aliases.csv'.
#
# Usage:
#   ./.github/scripts/extract_gutenberg_author_aliases.sh

source ./.github/scripts/extract/extract_table.sh

table_name="gutenberg_author_aliases"
query="PREFIX pgterms: <http://www.gutenberg.org/2009/pgterms/>
SELECT ?gutenberg_author_id ?alias
WHERE {
  GRAPH <http://gutenberg.org/graph/catalog> {
    ?entity a pgterms:agent .
    ?entity pgterms:alias ?alias .
    BIND(STRAFTER(STR(?entity), '/agents/') AS ?gutenberg_author_id)
  }
}"

extract_table "$table_name" "$query"
