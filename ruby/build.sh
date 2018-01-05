#!/bin/bash
set -e
version=$(cat VERSION)
ruby_versions=("2.2" "2.3" "2.4" "2.5")
for ruby in ${ruby_versions[@]}
do
	tag="voxmedia/ruby:$ruby-$version"
	docker build . --build-arg RUBY_VERSION=$ruby -t $tag
	docker push $tag
done
