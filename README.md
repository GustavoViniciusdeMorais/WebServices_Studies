# Web Services Study

Created By: Gustavo Morais.

- [HTTP Nginx](./nginx.md)
- [Queue Rabbitmq](./rabbitmq.md)

### Nginx Docker
```sh
docker exec -it -u 0 ngubuntu bash

apt update

apt install nginx -y

service --status-all

apt install nano

apt install curl -y

```

### Read error logs
```
sudo tail -f /var/log/nginx/error.log
sudo chown -R nginx:nginx /var/www/html
```

