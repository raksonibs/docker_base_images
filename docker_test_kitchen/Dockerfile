FROM ruby:2.2.2

RUN apt-get update \
  && apt-get install -y apt-transport-https ca-certificates locales \
  # Setup the en_US.UTF-8 language settings because ruby 
  && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
  && locale-gen \
  && apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D \
	&& echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list \
	&& apt-get update \
	&& apt-get install -y docker-engine=1.10.3-0~jessie \
  && rm -rf /var/lib/apt/lists/* \
  && gem install bundler -v 1.16.0 \
  && mkdir /app \
  && mkdir /app/tmp \
  && mkdir /root/.ssh \
  && ssh-keyscan github.com >> /root/.ssh/known_hosts

ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

ADD ci_test.sh /usr/local/bin/
CMD ci_test.sh
WORKDIR /app
