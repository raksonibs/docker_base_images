set -e
version=$(cat VERSION)
ruby_versions=("2.2" "2.3" "2.4")
for ruby in ${ruby_versions[@]}
do
	git tag "ruby/$ruby-$version"
done
git push --tags
