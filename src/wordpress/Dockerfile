FROM debian:buster

RUN apt-get update && \
  apt-get --yes --no-install-recommends install php7.3 php-mysqli php-fpm wget sendmail \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/lib/wp

EXPOSE 9000

COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d
COPY ./bin /usr/local/bin
COPY ./init /etc/wp

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

CMD ["/usr/sbin/php-fpm7.3", "--nodaemonize"]