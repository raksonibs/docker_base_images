FROM docker.voxops.net/ruby:2.5-3.0.2

WORKDIR /app
ADD Gemfile* /app/

RUN docker-ssh-exec bundle install

ENTRYPOINT ["/opt/entrypoint/dispatcher.sh", "bundle", "--"]
