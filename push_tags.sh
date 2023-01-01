#!/usr/bin/env bash
set -e

echo "Assuming `docker login` was run before this..."


docker push retrodaredevil/openttd:1.11.2
docker push retrodaredevil/openttd:12.0
docker push retrodaredevil/openttd:12.1
docker push retrodaredevil/openttd:12.2
docker push retrodaredevil/openttd:13.0-beta2
docker push retrodaredevil/openttd:latest

echo "You should run `docker logout` now."
