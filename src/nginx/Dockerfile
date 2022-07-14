FROM debian:buster

RUN apt-get update
RUN apt-get install -y nginx openssl

EXPOSE 443

COPY ./conf/default /etc/nginx/sites-enabled/default
COPY ./bin/nginx_start.sh /usr/local/bin

ENTRYPOINT [ "/usr/local/bin/nginx_start.sh" ]

CMD ["nginx", "-g", "daemon off;"]
