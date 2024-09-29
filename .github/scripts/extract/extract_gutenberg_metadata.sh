#!/bin/bash

# Source the extract_table function
source ./extract_table.sh

# Define variables specific to the gutenberg_metadata table
table_name="gutenberg_metadata"
query="PREFIX pgterms: <http://www.gutenberg.org/2009/pgterms/>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX locrelators: <http://id.loc.gov/vocabulary/relators/>

SELECT ?entity ?title ?creator ?language ?rights ?issued ?bookshelf ?description 
       ?alternative ?publisher ?license ?marc508 ?marc010 ?tableOfContents ?subject 
       ?downloads ?marc905 ?marc906 ?marc907 ?marc520 ?marc300 
       ?loc_ill ?loc_trl ?loc_edt ?loc_prf ?loc_ctb ?loc_pbl ?loc_art 
       ?loc_aft ?loc_cmp
WHERE {
  GRAPH <http://gutenberg.org/graph/catalog> {
    ?entity a pgterms:ebook .
    OPTIONAL { ?entity dcterms:title ?title } .
    OPTIONAL { ?entity dcterms:creator ?creator } .
    OPTIONAL { ?entity dcterms:language ?language } .
    OPTIONAL { ?entity dcterms:rights ?rights } .
    OPTIONAL { ?entity dcterms:issued ?issued } .
    OPTIONAL { ?entity pgterms:bookshelf ?bookshelf } .
    OPTIONAL { ?entity dcterms:description ?description } .
    OPTIONAL { ?entity dcterms:alternative ?alternative } .
    OPTIONAL { ?entity dcterms:publisher ?publisher } .
    OPTIONAL { ?entity dcterms:license ?license } .
    OPTIONAL { ?entity dcterms:tableOfContents ?tableOfContents } .
    OPTIONAL { ?entity dcterms:subject ?subject } .
    OPTIONAL { ?entity pgterms:downloads ?downloads } .
    OPTIONAL { ?entity pgterms:marc508 ?marc508 } .
    OPTIONAL { ?entity pgterms:marc010 ?marc010 } .
    OPTIONAL { ?entity pgterms:marc905 ?marc905 } .
    OPTIONAL { ?entity pgterms:marc906 ?marc906 } .
    OPTIONAL { ?entity pgterms:marc907 ?marc907 } .
    OPTIONAL { ?entity pgterms:marc520 ?marc520 } .
    OPTIONAL { ?entity pgterms:marc300 ?marc300 } .
    OPTIONAL { ?entity locrelators:ill ?loc_ill } .
    OPTIONAL { ?entity locrelators:trl ?loc_trl } .
    OPTIONAL { ?entity locrelators:edt ?loc_edt } .
    OPTIONAL { ?entity locrelators:prf ?loc_prf } .
    OPTIONAL { ?entity locrelators:ctb ?loc_ctb } .
    OPTIONAL { ?entity locrelators:pbl ?loc_pbl } .
    OPTIONAL { ?entity locrelators:art ?loc_art } .
    OPTIONAL { ?entity locrelators:aft ?loc_aft } .
    OPTIONAL { ?entity locrelators:cmp ?loc_cmp } .
  }
}"

# Call the extract_table function with the appropriate arguments
extract_table "$table_name" "$query" "gutenberg_id"

