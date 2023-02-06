FROM alpine:3.14

# - update and upgrade the Alpine Linux package manager packages
# - install nginx packages along with other dependencies
RUN apk update \
  && apk upgrade \
  && apk add --no-cache nginx openssl gettext

# - create the nginx daemon directory if it doesn't exist
# - remove any configuration files
RUN mkdir -p /etc/nginx/http.d/ \
  && rm /etc/nginx/http.d/*.conf

# - copy the config file to container root as a template file
COPY ./conf/default.conf /default.conf.tmpl

# - copy the setup script to the container root
COPY ./tools/run.sh /run.sh

# - set the setup script as executable
RUN chmod +x /run.sh

ENTRYPOINT [ "/run.sh" ]