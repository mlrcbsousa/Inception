#!/bin/sh

CONFIG='/etc/nginx/http.d/default.conf'

# Check if config file has already been created by a previous run of this script
if [ -e $CONFIG ]; then
	  echo "Nginx config already created"
else

    # Hydrate configuration template with env variables and create config file
    cat /default.conf.tmpl \
        | envsubst '$NGINX_PORT $DOMAIN $CERTIFICATE_PATH $PRIVATE_KEY_PATH $VOLUME_WORDPRESS_MOUNT_PATH $WORDPRESS_PORT' \
        > $CONFIG

    # N.B. `envsubst` has to be specific ones or will empty fastcgi_params
fi

# Run Nginx as a foreground process and passes any command line arguments passed
# to the script to Nginx.
exec nginx -g 'daemon off;' $@