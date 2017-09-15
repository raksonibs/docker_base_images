set -e
version=$(cat VERSION)
ruby_versions=("2.2" "2.3" "2.4")
for ruby in ${ruby_versions[@]}
do
	tag="voxmedia/docker_base_images:ruby_$ruby-$version"
	docker build . --build-arg RUBY_VERSION=$ruby -t $tag
	docker push $tag
done
