FROM ruby:2.2.2

RUN apt-get update \
  && apt-get install -y apt-transport-https ca-certificates \
  && apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D \
	&& echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list \
	&& apt-get update \
	&& apt-get install -y docker-engine \
	&& service docker start \
  && rm -rf /var/lib/apt/lists/* \
  && gem install bundler \
  && mkdir /app \
  && mkdir /app/tmp \
  && mkdir /root/.ssh \
  && ssh-keyscan github.com >> /root/.ssh/known_hosts

WORKDIR /app
