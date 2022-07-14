FROM debian:buster

RUN apt-get update \
  && apt-get install --yes --no-install-recommends nginx openssl \
  && rm -rf /var/lib/apt/lists/*

EXPOSE 443

COPY ./conf/default /etc/nginx/sites-enabled/default
COPY ./bin /usr/local/bin

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

CMD ["nginx", "-g", "daemon off;"]
