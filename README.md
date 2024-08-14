# API Gateway

### Nginx config
```conf
events {
    # You can leave this block empty or configure specific settings if needed
    worker_connections 1024;
}

http {
    upstream users_api_server {
        ip_hash;
        server api_python:8000;
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
cat nginx/default.conf > /etc/nginx/nginx.conf
nginx -t
service nginx start
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

### Test api gateway
```sh
curl --request GET http://localhost:81/api/users
```
