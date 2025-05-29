#!/bin/bash
# Description:
#   Extract ebook author data from the Project Gutenberg RDF graph and store it
#   in 'gutenberg_ebook_authors.csv'.
#
# Usage:
#   ./.github/scripts/extract_gutenberg_ebook_authors.sh

source ./.github/scripts/extract/extract_table.sh

table_name="gutenberg_ebook_authors"
query="PREFIX pgterms: <http://www.gutenberg.org/2009/pgterms/>
PREFIX dcterms: <http://purl.org/dc/terms/>
SELECT ?gutenberg_id ?gutenberg_author_id
WHERE {
  GRAPH <http://gutenberg.org/graph/catalog> {
    ?ebook a pgterms:ebook .
    ?ebook dcterms:creator ?creator .
    BIND(STRAFTER(STR(?ebook), '/ebooks/') AS ?gutenberg_id)
    BIND(STRAFTER(STR(?creator), '/agents/') AS ?gutenberg_author_id)
  }
}"

# Call the extract_table function with the appropriate arguments
extract_table "$table_name" "$query"
