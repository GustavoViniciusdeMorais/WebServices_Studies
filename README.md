# NGINX Study

Created By: Gustavo Morais.

### Installs
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

### Copy files from container to local folder
```
docker cp container_id:/etc/nginx/ server/
```

### Server criation
```sh
cd /var/www/

mkdir mysite

cd mysite

nano index.html

cd /etc/nginx/sites-available/

ip addr

nano mysite.conf

```

### index.html
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>HTML5</title>
</head>
<body>
    Gustavo
</body>
</html>
```

#### mysite.conf
```conf
server {
    listen 10.0.0.3:80;

    root /var/www/mysite;

    index index.html;
}
```

### Enable site config
```sh

cd /etc/nginx/sites-enabled/

ln -s /etc/nginx/sites-available/mysite.conf /etc/nginx/sites-enabled/mysite

service nginx status

service nginx restart

service nginx status

nginx -t # test if nginx config is fine

```

### Test if config is running
```
curl 10.0.0.3
```

### Config second site
```bash
cp /var/www/html/nginx/second.conf /etc/nginx/sites-available/second
ln -s /etc/nginx/sites-available/second /etc/nginx/sites-enabled/second
ls -lh /etc/nginx/sites-enabled/
nginx -t
curl [IP_SERVER]:81/second
```
### Second conf file
```
server {
    listen 81;
    server_name second;

    root /var/www/html/php/second;
    location /second {
        try_files $uri $uri/ /index.php?$query_string;
    }
    ...
}
```
