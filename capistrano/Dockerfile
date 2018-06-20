FROM docker.voxops.net/ruby:2.5-3.0.1

COPY entrypoint.sh /opt/entrypoint.sh
RUN chmod -R +x /opt/entrypoint.sh

WORKDIR /app
ADD Gemfile* /app/

RUN docker-ssh-exec bundle install

ENTRYPOINT ["/opt/entrypoint.sh"]
