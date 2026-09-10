### Advanced Nginx
Config requests limits
```yml
# Rate limit zone: track per IP (states stored in 10MB shared memory)
limit_req_zone $binary_remote_addr zone=perip:10m rate=1r/m;

upstream api_backend {
    server api1:3003;
    server api2:3003;
}

server {
    listen 81;
    server_name api;

    location / {
        # Apply rate limit: 1 request per minute, no burst, immediate rejection
        limit_req zone=perip burst=0 nodelay;
        limit_req_status 429;

        proxy_pass http://api_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```
