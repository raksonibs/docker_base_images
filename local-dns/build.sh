#!/bin/bash
set -e
TAG="voxmedia/local-dns:$(cat VERSION)"
docker build  --no-cache -t $TAG .
docker push $TAG
