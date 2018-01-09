#!/bin/bash
set -e
version=$(cat VERSION)
ruby_versions=("2.2" "2.3" "2.4" "2.5")
for ruby in ${ruby_versions[@]}
do
	tag="voxmedia/ruby:$ruby-$version"
	[[ $ruby == "2.5" ]] && libmysqlclient="default-libmysqlclient-dev" || libmysqlclient="libmysqlclient-dev"
	docker build . --build-arg RUBY_VERSION=$ruby --build-arg LIBMYSQLCLIENT=$libmysqlclient -t $tag
	docker push $tag
done
