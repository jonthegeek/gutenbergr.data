#!/bin/bash
# Description:
#   Set up Oxigraph and wait for the server to be ready.
#
# Usage:
#   ./.github/scripts/setup_oxigraph.sh

docker run -d --name oxigraph_server \
  -v $GITHUB_WORKSPACE/oxigraph_db:/data \
  -p 7878:7878 oxigraph/oxigraph:latest

until curl -s http://localhost:7878 > /dev/null; do
  echo "⏳ Waiting for Oxigraph server to start..."
  sleep 2
done
