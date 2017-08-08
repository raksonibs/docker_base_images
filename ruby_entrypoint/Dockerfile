FROM voxmedia/docker_base_images:ruby_2.3-0.1

ENV LC_ALL C.UTF-8

ADD https://s3.amazonaws.com/voxmedia-docker-utils/docker-ssh-exec /usr/local/bin/docker-ssh-exec
RUN chmod +x /usr/local/bin/docker-ssh-exec

ADD scripts /opt/entrypoint/
RUN chmod -R +x /opt/entrypoint/*
