#!/usr/bin/env bash
set -e

# Versions here: https://github.com/OpenTTD/OpenTTD/releases

docker build -t retrodaredevil/openttd:1.11.2 --build-arg OPENTTD_VERSION=1.11.2 .
docker build -t retrodaredevil/openttd:12.0 --build-arg OPENTTD_VERSION=12.0 .
docker build -t retrodaredevil/openttd:12.1 --build-arg OPENTTD_VERSION=12.1 .
docker build -t retrodaredevil/openttd:12.2 --build-arg OPENTTD_VERSION=12.2 .
docker build -t retrodaredevil/openttd:13.0-beta2 --build-arg OPENTTD_VERSION=13.0-beta2 .
docker build -t retrodaredevil/openttd:latest .
