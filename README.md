# Inception

Set up a small infrastructure composed of WordPress with LEMP Stack (Nginx, MariaDB and PHP) using **docker-compose**.

## Docker

Add docker group to login user in your virtual machine.

```bash
sudo adduser msousa docker
sudo reboot
```

## Run

Build and start project

```bash
make
```

Bring infrastructure down

```bash
make down
```

Start without re-building

```bash
make up
```

## Login Domain

Hosts added as part of `up` command, can be accessed via:

```bash
make hosts
```

### Nginx

Generate Certificate Authority (CA) `.key` and `.crt` files, server `.key` and server `.crt` files:

```bash
make certs
```

Run as part of `all` command.

Manually add certificate to the browser.

## Debug

Run a **sh** shell inside one of the containers:

```bash
make mariadb
make wordpress
make nginx
```

Recreate one service:

```bash
cd srcs && docker-compose up -d --force-recreate --build --no-deps nginx
```