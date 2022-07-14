FROM debian:buster

RUN apt-get update
RUN apt-get install -y mariadb-server

EXPOSE 3306

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY ./init /etc/mariadb

RUN service mysql start && mysql < /etc/mariadb/initial_db.sql && rm -f /etc/mariadb/initial_db.sql;

CMD ["mysqld"]