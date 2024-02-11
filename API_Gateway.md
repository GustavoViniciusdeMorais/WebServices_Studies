# API Gateway

### 
```sh
```

### Nginx config
```conf
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
```

### Build config alias to file
```sh
ln -s /etc/nginx/sites-available/api_gateway.conf /etc/nginx/sites-enabled/api_gateway
```

### Start api gateway
```sh
nginx -t # test if server config is ok
service nginx start
```

### Test api gateway
Before it, start the fast api inside python container.
```sh
curl --request GET http://localhost:81/api/users
```
