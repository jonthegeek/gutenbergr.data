#!/bin/bash
# Description:
#   Extract ebook language tags from the Project Gutenberg RDF graph and
#   store them in 'gutenberg_ebook_languages.csv'.
#
# Usage:
#   ./.github/scripts/extract_gutenberg_ebook_languages.sh

source ./.github/scripts/extract/extract_table.sh

table_name="gutenberg_ebook_languages"
query="PREFIX pgterms: <http://www.gutenberg.org/2009/pgterms/>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
SELECT ?gutenberg_id ?language
WHERE {
  GRAPH <http://gutenberg.org/graph/catalog> {
    ?entity a pgterms:ebook .
    ?entity dcterms:language ?lang_node .
    ?lang_node rdf:value ?language .
    BIND(STRAFTER(STR(?ebook), '/ebooks/') AS ?gutenberg_id)
  }
}"

extract_table "$table_name" "$query"
