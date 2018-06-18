#!/bin/bash
set -e

MAJOR_VERSION=${1:-2.5}

# Get the latest minor version of the given MAJOR_VERSION by parsing ruby-lang.org releases page
version_info=$(curl -s https://www.ruby-lang.org/en/downloads/releases/ | grep "Ruby ${MAJOR_VERSION}" | head -1)
if [[ ${version_info} =~ ${MAJOR_VERSION}\.[[:digit:]]+ ]]; then
  RUBY_VERSION=${BASH_REMATCH}
else
  echo "Unable to find latest release for major version ${MAJOR_VERSION}"
  exit 1
fi

mkdir -p /usr/local/etc
echo 'install: --no-document' >> /usr/local/etc/gemrc
echo 'update: --no-document' >> /usr/local/etc/gemrc

set -x

echo "Installing Ruby ${RUBY_VERSION}"

apt-get update
apt-get install -y --no-install-recommends \
  bison \
  libssl-dev \
  libyaml-dev \
  libreadline6-dev \
  zlib1g-dev \
  libncurses5-dev \
  libffi-dev \
  libgdbm-dev
rm -rf /var/lib/apt/lists/*

mkdir -p /usr/src/ruby

curl -o ruby.tar.xz https://cache.ruby-lang.org/pub/ruby/${MAJOR_VERSION}/ruby-${RUBY_VERSION}.tar.xz
tar -xJf ruby.tar.xz -C /usr/src/ruby --strip-components=1
rm ruby.tar.xz
cd /usr/src/ruby

# hack to suppress "# warning: Insecure world writable dir"
echo '#define ENABLE_PATH_CHECK 0' > file.c.new
echo >> file.c.new
cat file.c >> file.c.new
mv file.c.new file.c

autoconf
gnu_arch=$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)
./configure \
  --build="${gnu_arch}" \
  --disable-install-doc \
  --enable-shared
make -j "$(nproc)"
make install

cd /root
rm -rf /usr/src/ruby
