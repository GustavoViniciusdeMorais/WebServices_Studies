# API Gateway

### Nginx config
- [Explanation](./nginx_config_details.md)

Load balancer example
```conf
events {
    # You can leave this block empty or configure specific settings if needed
    worker_connections 1024;
}

http {
    upstream users_api_server {
        #ip_hash;
        server api_python:8000;
        server api_php:80;
    }

    limit_req_zone $binary_remote_addr zone=user_rate:10m rate=1r/s;

    server {
        listen 81 default_server;
        listen [::]:81 default_server;

        #
        # Users API
        #
        location /api/users {
            limit_req zone=user_rate;
            limit_req_status 429;
            proxy_pass http://users_api_server;
        }
    }
}

```

### Config the nginx with default file conf
```sh
sudo ./dockermg.sh ngubuntu bash
cat nginx/default.conf > /etc/nginx/sites-available/default
nginx -t
service nginx start
```

### Config the three servers
Enter each server and start their processes
```bash
# php server, docker already copied the configs
docker exec -it -u 0 api_php bash
nginx -t
service nginx start
service php8.1-fpm start

# python
docker exec -it -u 0 api_python
uvicorn main:app --reload --host=0.0.0.0

# nginx main gateway
docker exec -it -u 0 ngubuntu bash
cat nginx/default.conf > /etc/nginx/sites-available/default
nginx -t
service nginx start
```

### Test api gateway
Each request, one server will respond
```bash
curl --request GET http://localhost:81/api/users
```

### Other option is to build config alias to file
```sh
ln -s /etc/nginx/sites-available/api_gateway.conf /etc/nginx/sites-enabled/api_gateway
```

### Start python api
```sh
sudo ./dockermg.sh api_python sh
uvicorn main:app --reload --host=0.0.0.0
```