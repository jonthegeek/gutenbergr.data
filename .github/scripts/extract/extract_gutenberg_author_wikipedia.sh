#!/bin/bash
# Description:
#   Extract ebook author webpage links from the Project Gutenberg RDF graph and
#   store them in 'gutenberg_author_wikipedia.csv'.
#
# Usage:
#   ./.github/scripts/gutenberg_author_wikipedia.sh

source ./.github/scripts/extract/extract_table.sh

table_name="gutenberg_author_wikipedia"
query="PREFIX pgterms: <http://www.gutenberg.org/2009/pgterms/>
SELECT ?gutenberg_author_id ?wikipedia
WHERE {
  GRAPH <http://gutenberg.org/graph/catalog> {
    ?entity a pgterms:agent .
    ?entity pgterms:webpage ?wikipedia .
    BIND(STRAFTER(STR(?entity), '/agents/') AS ?gutenberg_author_id)
  }
}"

extract_table "$table_name" "$query"
