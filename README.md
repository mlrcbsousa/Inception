# Inception

42 school Inception project

Set up a small infrastructure composed of WordPress with LEMP Stack (Nginx, MariaDB and PHP) using `docker-compose`.



```
docker build --no-cache -t nginx .
docker ps
docker run -p 127.0.0.1:80:80/tcp --name nginx nginx
docker exec -it nginx bash
```

