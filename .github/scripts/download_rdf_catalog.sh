#!/bin/bash
# Description:
#   Download the RDF catalog from Project Gutenberg and extract it into the
#   specified directory.
#
# Usage:
#   ./.github/scripts/download_rdf_catalog.sh <rdf_dir>
#
# Arguments:
#   rdf_dir   The directory where the RDF files should be extracted.

rdf_dir=$1
mkdir -p "$rdf_dir"
curl -o rdf-files.tar.bz2 https://www.gutenberg.org/cache/epub/feeds/rdf-files.tar.bz2
tar -xjf rdf-files.tar.bz2 -C "$rdf_dir"
