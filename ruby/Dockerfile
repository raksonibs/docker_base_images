ARG RUBY_VERSION=latest
ARG LIBMYSQLCLIENT=libmysqlclient-dev
FROM ruby:${RUBY_VERSION}

RUN echo "deb http://apt.gemnasium.com stable main" > /etc/apt/sources.list.d/gemnasium.list \
  && apt-key adv --recv-keys --keyserver keyserver.ubuntu.com E5CEAB0AC5F1CA2A \
  && apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y gemnasium-toolbelt ${LIBMYSQLCLIENT} mysql-client \
  && rm -rf /var/lib/apt/lists/* \
  && gem install bundler -v 1.16.0 \
  && mkdir /app \
  && mkdir /app/tmp \
  && mkdir /root/.ssh \
  && ssh-keyscan github.com >> /root/.ssh/known_hosts

# Setup a common bundler configuration
ENV BUNDLE_JOBS=4 \
    BUNDLE_APP_CONFIG=/root/.bundle

ENV LC_ALL C.UTF-8

ADD https://s3.amazonaws.com/voxmedia-docker-utils/docker-ssh-exec /usr/local/bin/docker-ssh-exec
RUN chmod +x /usr/local/bin/docker-ssh-exec

ADD build_scripts /opt/build/
RUN chmod -R +x /opt/build/*

ADD entrypoint_scripts /opt/entrypoint/
RUN chmod -R +x /opt/entrypoint/*
