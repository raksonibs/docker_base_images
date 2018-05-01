#!/usr/bin/env bash
set -Eeuo pipefail

# need to install jq to parse the response from the golang version api
apt-get update
apt-get install -y jq
rm -rf /var/lib/apt/lists/*

# https://github.com/golang/go/issues/13220
allGoVersions=()
apiBaseUrl='https://www.googleapis.com/storage/v1/b/golang/o?fields=nextPageToken,items%2Fname'
pageToken=
while [ "$pageToken" != 'null' ]; do
	page="$(curl -fsSL "$apiBaseUrl&pageToken=$pageToken")"
	allGoVersions+=( $(
		echo "$page" \
			| jq -r '.items[].name' \
			| grep -E '^go[0-9].*[.]src[.]tar[.]gz$' \
			| sed -E -e 's!^go!!' -e 's![.]src[.]tar[.]gz$!!'
	) )
	# TODO extract per-version "available binary tarballs" information while we've got it handy here?
	pageToken="$(echo "$page" | jq -r '.nextPageToken')"
done

fullVersion="$(
	echo "${allGoVersions[@]}" | xargs -n1 \
	| grep "${GOLANG_VERSION}" \
	| sort -V \
	| tail -1
)" || true

if [ -z "$fullVersion" ]; then
	echo >&2 "warning: cannot find full version for $GOLANG_VERSION"
	continue
else
	echo "Found matching version -- ${fullVersion}"
fi

dpkgArch="$(dpkg --print-architecture)" || true
case "${dpkgArch##*-}" in
	amd64) goArch='linux-amd64';;
	armhf) goArch='linux-armv6l';;
	arm64) goArch='linux-arm64';;
	i386) goArch='linux-386';;
	ppc64el) goArch='linux-ppc64le';;
	s390x) goArch='linux-s390x';;
	*) goArch='src';
		echo >&2; echo >&2 "warning: current architecture ($dpkgArch) does not have a corresponding Go binary release; will be building from source"; echo >&2 ;;
esac;
echo "curling https://storage.googleapis.com/golang/go${fullVersion}.${goArch}.tar.gz.sha256"
sha256="$(curl -fsSL "https://storage.googleapis.com/golang/go${fullVersion}.${goArch}.tar.gz.sha256")"
echo "sha: ${sha256}"

url="https://golang.org/dl/go${fullVersion}.${goArch}.tar.gz";
wget -O go.tgz "$url";
echo "${sha256} *go.tgz" | sha256sum -c -;
tar -C /usr/local -xzf go.tgz;
rm go.tgz;

if [ "$goArch" = 'src' ]; then
	echo >&2;
	echo >&2 'error: UNIMPLEMENTED';
	echo >&2 'TODO install golang-any from backports for GOROOT_BOOTSTRAP (and uninstall after build)';
	echo >&2;
	exit 1;
fi;

/usr/local/go/bin/go version

mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

if [[ $fullVersion == 1.10* ]]; then
	echo "go-wrapper is not required for versions > 1.10";
else
	echo "downloading go-wrapper"
	curl -o /usr/local/bin/go-wrapper -L https://raw.githubusercontent.com/docker-library/golang/master/go-wrapper
	chmod +x /usr/local/bin/go-wrapper
fi;
