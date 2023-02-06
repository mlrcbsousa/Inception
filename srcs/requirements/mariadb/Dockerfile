FROM alpine:3.7

# - update and upgrade the Alpine Linux package manager packages
# - install the packages for MariaDB database, MariaDB client, gettext, and
#   openrc without caching the package files
RUN apk update \
  && apk upgrade \
  && apk add --no-cache mariadb mariadb-client gettext

# "envsubst" is included in the "gettext" package in Alpine Linux. "envsubst"
# is a utility that substitutes the values of environment variables with their
# values in a string. It is often used to substitute values in configuration
# files, scripts, or other text files with values from the environment, which
# can be useful for configuration management or deployment.

# - create directory "/run/mysqld" if it doesn't exist
# - change the ownership of the "/run/mysqld" directory and its subdirectories to
#   user "mysql" and group "mysql"
RUN mkdir -p /run/mysqld \
  && chown -R mysql:mysql /run/mysqld

# - copy the config file to container root as a template file
COPY ./conf/my.cnf /my.cnf.tmpl

# - set the permissions of the template config file to be readable, writeable, and
#   executable by the owner and only readable by others
RUN chmod 744 /my.cnf.tmpl

# - remove the default config file if it exists
RUN rm -f /etc/mysql/my.cnf

# - copy the database configuration file to the container root
COPY ./conf/tmpl.sql /tmpl.sql

# - copy the setup script to the container root
COPY ./tools/run.sh /run.sh

# - set the setup script as executable
RUN chmod +x /run.sh

# - create a Docker volume that maps the host's "/sys/fs/cgroup" file system to
#   the same location within the container
VOLUME [ "/sys/fs/cgroup" ]

# Mapping the host's "/sys/fs/cgroup" file system to the same location within
# the container via a volume can be useful in some cases where you need to run
# the container in privileged mode to access specific host-level resources, such
# as cgroups. This allows you to manage the container's resource usage and ensure
# that it does not consume too many host resources.

# "/sys/fs/cgroup" is a virtual file system in the Linux operating system that
# provides a unified interface for managing and isolating resources such as CPU,
# memory, and I/O for system processes. It is used by the control groups (cgroups)
# feature in the Linux kernel to limit, prioritize, and distribute these resources
# among system processes. Mapping the host's "/sys/fs/cgroup" file system to the
# same location within a Docker container allows the container to access the host's
# cgroup information and use it to manage its own resource usage.

# - expose port 3306 in the Docker container, allowing network access
EXPOSE 3306

# using CMD useful to override executable like `docker run -it mariadb sh` to debug
# CMD [ "/run.sh" ]

ENTRYPOINT [ "/run.sh" ]