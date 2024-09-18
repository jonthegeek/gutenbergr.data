load_rdf() {
  RDF_DIR=./pg_rdf_files/cache/epub
  curl -X POST --data-binary @$RDF_DIR/$1/pg$1.rdf \
    -H 'Content-Type: application/rdf+xml' \
    http://localhost:7878/store?graph=http://gutenberg.org/graph/catalog 2>>error_log.txt
}
