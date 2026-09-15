# NGINX default.conf

**Context:** Included inside `http { }` via `sites-enabled/`.  
The file itself has no `http` block. `upstream` and `limit_req_zone` are http-level; `server` is also http-level.

## Upstream
`upstream users_api_server` – Load-balances between `api_python:8000` and `api_php:80`.  
Default: round-robin. Uncomment `ip_hash;` for sticky sessions.

## Rate limit
`limit_req_zone $binary_remote_addr zone=user_rate:10m rate=1r/s;`
- Per-IP: 1 request/sec.
- 10 MB shared memory for IP states.

## Server (port 81)
- `listen 81 default_server;` – IPv4 default on port 81.
- `listen [::]:81 default_server;` – IPv6 default on port 81.

### Location `/api/users`
- `limit_req zone=user_rate;` – Apply rate limit.
- `limit_req_status 429;` – Return 429 when exceeded.
- `proxy_pass http://users_api_server;` – Forward to upstream.

If you ever move these directives directly into `nginx.conf`, they must go inside the existing `http { }` block — not inside a `server` block.
