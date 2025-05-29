#!/bin/bash

# Source the extract_table function
source ./.github/scripts/extract/extract_table.sh

# Define variables specific to the gutenberg_metadata table
table_name="gutenberg_metadata"
query="PREFIX pgterms: <http://www.gutenberg.org/2009/pgterms/>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX locrelators: <http://id.loc.gov/vocabulary/relators/>
SELECT ?gutenberg_id ?title ?creator ?language ?rights ?issued ?bookshelf ?description
       ?alternative ?publisher ?license ?tableOfContents ?subject ?downloads
       ?loc_adapter ?loc_afterword ?loc_annotator ?loc_arranger ?loc_artist
       ?loc_authorinterviewee ?loc_collaborator ?loc_commentator ?loc_composer
       ?loc_conductor ?loc_compiler ?loc_contributor ?loc_dubber ?loc_editor
       ?loc_engraver ?loc_forger ?loc_illustrator ?loc_librettist ?loc_other
       ?loc_publisher ?loc_photographer ?loc_performer ?loc_printer
       ?loc_researcher ?loc_transcriber ?loc_translator ?loc_unknown ?marc_lccn
       ?marc_isbn ?marc_edition ?marc_publication ?marc_physicaldesc
       ?marc_series ?marc_credits ?marc_summary ?marc_language ?marc_local901
       ?marc_local902 ?marc_local903 ?marc_local904 ?marc_local905
       ?marc_local906 ?marc_local907
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
    OPTIONAL { ?entity locrelators:adp ?loc_adapter } .
    OPTIONAL { ?entity locrelators:aft ?loc_afterword } .
    OPTIONAL { ?entity locrelators:ann ?loc_annotator } .
    OPTIONAL { ?entity locrelators:arr ?loc_arranger } .
    OPTIONAL { ?entity locrelators:art ?loc_artist } .
    OPTIONAL { ?entity locrelators:aui ?loc_authorinterviewee } .
    OPTIONAL { ?entity locrelators:clb ?loc_collaborator } .
    OPTIONAL { ?entity locrelators:cmm ?loc_commentator } .
    OPTIONAL { ?entity locrelators:cmp ?loc_composer } .
    OPTIONAL { ?entity locrelators:cnd ?loc_conductor } .
    OPTIONAL { ?entity locrelators:com ?loc_compiler } .
    OPTIONAL { ?entity locrelators:ctb ?loc_contributor } .
    OPTIONAL { ?entity locrelators:dub ?loc_dubber } .
    OPTIONAL { ?entity locrelators:edt ?loc_editor } .
    OPTIONAL { ?entity locrelators:egr ?loc_engraver } .
    OPTIONAL { ?entity locrelators:frg ?loc_forger } .
    OPTIONAL { ?entity locrelators:ill ?loc_illustrator } .
    OPTIONAL { ?entity locrelators:lbt ?loc_librettist } .
    OPTIONAL { ?entity locrelators:oth ?loc_other } .
    OPTIONAL { ?entity locrelators:pbl ?loc_publisher } .
    OPTIONAL { ?entity locrelators:pht ?loc_photographer } .
    OPTIONAL { ?entity locrelators:prf ?loc_performer } .
    OPTIONAL { ?entity locrelators:prt ?loc_printer } .
    OPTIONAL { ?entity locrelators:res ?loc_researcher } .
    OPTIONAL { ?entity locrelators:trc ?loc_transcriber } .
    OPTIONAL { ?entity locrelators:trl ?loc_translator } .
    OPTIONAL { ?entity locrelators:unk ?loc_unknown } .
    OPTIONAL { ?entity pgterms:marc010 ?marc_lccn } .
    OPTIONAL { ?entity pgterms:marc020 ?marc_isbn } .
    OPTIONAL { ?entity pgterms:marc250 ?marc_edition } .
    OPTIONAL { ?entity pgterms:marc260 ?marc_publication } .
    OPTIONAL { ?entity pgterms:marc300 ?marc_physicaldesc } .
    OPTIONAL { ?entity pgterms:marc440 ?marc_series } .
    OPTIONAL { ?entity pgterms:marc508 ?marc_credits } .
    OPTIONAL { ?entity pgterms:marc520 ?marc_summary } .
    OPTIONAL { ?entity pgterms:marc546 ?marc_language } .
    OPTIONAL { ?entity pgterms:marc901 ?marc_local901 } .
    OPTIONAL { ?entity pgterms:marc902 ?marc_local902 } .
    OPTIONAL { ?entity pgterms:marc903 ?marc_local903 } .
    OPTIONAL { ?entity pgterms:marc904 ?marc_local904 } .
    OPTIONAL { ?entity pgterms:marc905 ?marc_local905 } .
    OPTIONAL { ?entity pgterms:marc906 ?marc_local906 } .
    OPTIONAL { ?entity pgterms:marc907 ?marc_local907 } .
    BIND(STRAFTER(STR(?ebook), '/ebooks/') AS ?gutenberg_id)
  }
}"

# Call the extract_table function with the appropriate arguments
extract_table "$table_name" "$query"
