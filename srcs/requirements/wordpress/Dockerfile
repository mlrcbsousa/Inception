FROM alpine:3.14

LABEL architecture="arm64v8/aarch64"

ARG	WORDPRESS_VERSION=5.8.1

# - update and upgrade the Alpine Linux package manager packages
# - install PHP and mariadb-client packages along with other dependencies
RUN apk update \
  && apk upgrade \
  && apk add --no-cache wget gettext \
    php7 php7-fpm php7-mysqli php7-zip php7-gd \
    php7-mbstring php7-cli php7-opcache php7-zlib \
    php7-curl php7-json php7-iconv php7-gettext \
    php7-session php7-phar mariadb-client php7-pdo php7-pdo_mysql \
    php7-dom php7-ctype php7-bcmath php7-fileinfo php7-intl php7-mcrypt \
    php7-mysqlnd php7-openssl php7-pdo_pgsql php7-pdo_sqlite php7-posix \
    php7-simplexml php7-soap php7-tokenizer php7-xml php7-xmlreader \
    php7-xmlwriter

# - download the WordPress CLI and add it to the PATH and make executable
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	--output-document=/usr/local/bin/wp \
  && chmod +x /usr/local/bin/wp

# - create the wordpress directories
# - set the permissions of the template config file to be readable, writeable, and
#   executable by the owner and readable and writeable by others
RUN mkdir -p /run/php /var/www/html/wordpress \
  && chmod -R 755 /var/www/html/wordpress

# - add the "wps" group and user
RUN addgroup -S wps && adduser -S wps -G wps

# https://www.php.net/manual/en/install.fpm.php

# - copy the config file to container root as a template file
COPY ./conf/www.conf /www.conf.tmpl

# - remove the default config file if it exists
RUN rm -f /etc/php7/php-fpm.d/www.conf

WORKDIR /var/www/html/wordpress

# - download the WordPress core using the CLI
RUN wp core download --allow-root --version=$WORDPRESS_VERSION

# - copy the setup script to the container root
COPY ./tools/run.sh /run.sh

# - set the setup script as executable
RUN chmod +x /run.sh

ENTRYPOINT [ "/run.sh" ]