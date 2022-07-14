FROM debian:buster

RUN apt-get update
RUN apt-get -y install php7.3 php-mysqli php-fpm wget sendmail
RUN mkdir /var/lib/wp

EXPOSE 9000

COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d
COPY ./bin /usr/local/bin
COPY ./init /etc/wp

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

CMD ["/usr/sbin/php-fpm7.3", "--nodaemonize"]