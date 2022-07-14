FROM debian:buster

RUN apt-get update \
  && apt-get install --yes --no-install-recommends mariadb-server \
  && rm -rf /var/lib/apt/lists/*

EXPOSE 3306

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY ./init /etc/mariadb

RUN service mysql start && mysql < /etc/mariadb/initial_db.sql && rm -f /etc/mariadb/initial_db.sql;

CMD ["mysqld"]