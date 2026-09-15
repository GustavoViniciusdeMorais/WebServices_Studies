# API Gateway

### Nginx config
- [Explanation](./nginx_config_details.md)

#### Load balancer example
The configs of events and http belongs to /etc/nginx/nginx.conf<br>
The following is for /etc/nginx/sites-available/default<br>
```conf
upstream users_api_server {
    #ip_hash;
    server api_python:8000;
    server api_php:80;
}

limit_req_zone $binary_remote_addr zone=user_rate:10m rate=1r/s;

server {
    listen 81 default_server;
    listen [::]:81 default_server;

    location /api/users {
        limit_req zone=user_rate;
        limit_req_status 429;
        proxy_pass http://users_api_server;
    }
}
```

### Config the three servers
Enter each server and start their processes
```bash
# start all containers
docker compose up -d --build

# nginx main gateway
docker exec -it -u 0 ngubuntu bash
cat /home/gustavo/nginx/default.conf > /etc/nginx/sites-available/default
nginx -t
service nginx start

# php server, docker already copied the configs
docker exec -it -u 0 api_php bash
nginx -t
service nginx start
service php8.1-fpm start

# python
docker exec -it -u 0 api_python sh
uvicorn main:app --reload --host=0.0.0.0
```

### Test api gateway
Each request, one server will respond
```bash
curl --request GET http://localhost:81/api/users && echo ""
```

### Other option is to build config alias to file
```sh
ln -s /etc/nginx/sites-available/api_gateway.conf /etc/nginx/sites-enabled/api_gateway
```
