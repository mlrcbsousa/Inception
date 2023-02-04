#!/bin/sh

# Sets the script to run in debug mode, which displays commands and their
# arguments as they are executed
set -x

# https://www.php.net/manual/en/install.fpm.php

# Check if config file has already been created by a previous run of this script
if [ -e /etc/php7/php-fpm.d/www.conf ]; then
	  echo "FastCGI Process Manager config already created"
else

    # Hydrate configuration template with env variables and create config file
    cat /www.conf.tmpl | envsubst > /etc/php7/php-fpm.d/www.conf
fi

# Check if wp-config.php file has already been created by a previous run
if [ -e wp-config.php ]; then
	  echo "Wordpress config already created"
else

    # Create the wordpress config file using environment variables
    wp config create --allow-root \
        --dbname=$WORDPRESS_DB_NAME \
        --dbuser=$MARIADB_USER_NAME \
        --dbpass=$MARIADB_USER_PASS \
        --dbhost=$MARIADB_HOST

    # Create the wordpress database using the config file created above
    wp db create --allow-root
fi

# Check if wordpress is already installed
if wp core is-installed --allow-root; then
	  echo "Wordpress core already installed"
else

    # Install wordpress with environment variables
    wp core install --allow-root \
        --url=$WORDPRESS_URL \
        --title=$WORDPRESS_TITLE \
        --admin_user=$WORDPRESS_ADMIN_NAME \
        --admin_email=$WORDPRESS_ADMIN_EMAIL \
        --admin_password=$WORDPRESS_ADMIN_PASS

    # create a new author user
    wp user create --allow-root \
        $WORDPRESS_USER_NAME \
        $WORDPRESS_USER_EMAIL \
        --role=author \
        --user_pass=$WORDPRESS_USER_PASS

    # Set the debugging mode of WordPress to false which will turn off debugging
    # messages, error reporting, and logging. Needed when using CLI from container
    wp config set WORDPRESS_DEBUG false --allow-root
fi

# Update all plugins
wp plugin update --all --allow-root

# Start the php-fpm7 process with the exec command, passing any additional
# arguments ($@)
echo "Start FastCGI Process Manager"
exec php-fpm7 --nodaemonize $@