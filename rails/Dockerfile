FROM voxmedia/docker_base_images:ruby_2.3-0.1

ENV LC_ALL C.UTF-8

ADD https://s3.amazonaws.com/voxmedia-docker-utils/docker-ssh-exec /usr/local/bin/docker-ssh-exec
RUN chmod +x /usr/local/bin/docker-ssh-exec

ADD entrypoint_scripts /opt/entrypoint/
RUN chmod -R +x /opt/entrypoint/*

# Install sudo
RUN apt-get update && apt-get install -y sudo vim \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create a non-root user "docker" to run as, with an arbitrary uid/gid
# The entrypoint will be responsible for later setting the uid/gid to match the host's
RUN \
  groupadd -f -g 9999 docker \
  && useradd --shell /bin/bash -u 9999 -g 9999 -m docker \
  # Also make the user a sudoer
  && echo "docker ALL=(ALL) NOPASSWD:SETENV:ALL" >> "/etc/sudoers" \
  && echo "Defaults always_set_home" >> "/etc/sudoers"

# Run all subsequent commands as the new user
USER docker
ENV HOME /home/dockerFROM voxmedia/docker_base_images:rails-0
WORKDIR $HOME

# Configure bundler
RUN sudo gem install bundler
ENV \
  BUNDLE_APP_CONFIG=$HOME/.bundle \
  BUNDLE_PATH=$HOME/bundle \
  BUNDLE_BIN=$HOME/bundle/bin \
  BUNDLE_JOBS=4 \
  BUNDLE_DISABLE_SHARED_GEMS=1
RUN bundle config PATH $BUNDLE_PATH
RUN bundle config BIN $BUNDLE_BIN
RUN bundle config JOBS $BUNDLE_JOBS
RUN bundle config DISABLE_SHARED_GEMS $BUNDLE_DISABLE_SHARED_GEMS
ENV PATH=$BUNDLE_BIN:$PATH

# Skip confirmation requirement for github authenticity warnings when installing bundle
RUN mkdir -p $HOME/.ssh
RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> $HOME/.ssh/config
