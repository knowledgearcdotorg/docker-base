FROM ubuntu:16.04
MAINTAINER development@knowledgearc.com

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update

RUN apt-get upgrade -y && \
    apt-get install -y supervisor && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir /run/supervisord

RUN sed \
    -i.orig \
    -e s/\\/var\\/run\\/supervisord.pid/\\/var\\/run\\/supervisord\\/supervisord.pid/g \
    -e s/\\/var\\/run\\/supervisor.sock/\\/var\\/run\\/supervisord\\/supervisor.sock/g \
    /etc/supervisor/supervisord.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
