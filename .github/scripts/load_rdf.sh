#!/bin/bash
# Description:
#   Load a single RDF file into an Oxigraph instance.
#
# Usage:
#   source ./.github/scripts/load_rdf.sh
#   load_rdf <rdf_dir> <id>
#
# Arguments:
#   rdf_dir   The path to the directory containing RDF files.
#   id        The ID of the RDF file to load.

load_rdf() {
  local rdf_dir=$1
  local id=$2
  curl --retry 3 -X POST --data-binary @$rdf_dir/$id/pg$id.rdf \
    -H 'Content-Type: application/rdf+xml' \
    http://localhost:7878/store?graph=http://gutenberg.org/graph/catalog 2>>error_log.txt
}
