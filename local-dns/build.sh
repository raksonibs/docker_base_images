#!/bin/bash
set -e
TAG="docker.voxops.net/local-dns:$(cat VERSION)"
docker build --no-cache -t $TAG .
docker push $TAG
