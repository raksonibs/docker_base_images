FROM ubuntu:16.04

ARG RUBY_VERSION=2.5

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    tzdata \
    file \
    curl \
    libcurl4-openssl-dev \
    wget \
    apt-transport-https \
    openssh-client \
    autoconf \
    build-essential \
    libmysqlclient-dev \
    mysql-client \
    git \
    vim \
    less \
    unzip \
    net-tools \
    iputils-ping \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir /root/.ssh \
  && ssh-keyscan github.com >> /root/.ssh/known_hosts

ENV LC_ALL C.UTF-8

ADD https://s3.amazonaws.com/voxmedia-docker-utils/docker-ssh-exec /usr/local/bin/docker-ssh-exec
RUN chmod +x /usr/local/bin/docker-ssh-exec

ADD build_scripts /opt/build/
RUN chmod -R +x /opt/build/*

ADD entrypoint_scripts /opt/entrypoint/
RUN chmod -R +x /opt/entrypoint/*

ENV GEM_HOME=/usr/local/bundle
ENV PATH=${GEM_HOME}/bin:${PATH} \
  BUNDLE_PATH=${GEM_HOME} \
  BUNDLE_BIN=${GEM_HOME}/bin/ \
  BUNDLE_APP_CONFIG=/root/.bundle \
  BUNDLE_SILENCE_ROOT_WARNING=1 \
  BUNDLE_JOBS=4
RUN mkdir -p ${GEM_HOME} \
  && chmod 777 ${GEM_HOME} \
  && /opt/build/install_ruby.sh ${RUBY_VERSION} \
  && gem install bundler -v 1.16.2

ARG IMAGE_VERSION
