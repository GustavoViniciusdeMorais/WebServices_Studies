### Upstream Blocks

1. **`upstream authUpstream`**: 
   - This block defines a group of backend servers for handling authentication-related requests.
   - `server auth:9090`: Specifies the backend server address (`auth`) and port (`9090`).
   - `max_fails=0`: Specifies that Nginx should not consider this server as failed regardless of the number of unsuccessful attempts.
   - `fail_timeout=10s`: Specifies the time during which Nginx will consider the server as down if it does fail.
   - `keepalive 512`: Specifies the number of idle keepalive connections to keep open.

2. **`upstream service1Upstream`**: 
   - This block defines another group of backend servers for handling requests to a service called `service1`.
   - `server services1:9091`: Specifies the backend server address (`services1`) and port (`9091`).
   - The rest of the parameters (`max_fails`, `fail_timeout`, `keepalive`) are the same as in the `authUpstream` block.

### Server Block

- **`server`**: This block defines a virtual server that handles incoming HTTP requests.

  - **`listen 80` and `listen [::]:80`**:
    - These directives tell Nginx to listen for HTTP requests on port 80 for both IPv4 and IPv6.

  - **`server_name api-gateway.local`**:
    - This directive specifies the domain name for which this server block is responsible.

  - **`location /service1/`**:
    - This location block handles requests with the path prefix `/service1/`.
    - `auth_request /auth-server/validate`: This directive sets up an internal request to the specified URI (`/auth-server/validate`) to check for authorization before proxying the request to the backend.
    - `auth_request_set $auth_status $upstream_status`: This sets the variable `$auth_status` to the status code returned by the authorization request.
    - `proxy_pass http://service1Upstream/`: This directive forwards the request to the `service1Upstream` upstream block.

  - **`location /auth-server/`**:
    - This location block handles requests to the path `/auth-server/`.
    - `internal`: This directive makes the location block inaccessible to external clients. It can only be accessed internally within Nginx.
    - `proxy_pass http://authUpstream/`: This directive forwards the request to the `authUpstream` upstream block.
    - `proxy_buffers 8 16k`: This sets the number and size of buffers used for storing responses from the proxied server.
    - `proxy_buffer_size 32k`: This sets the size of the buffer used for the first part of the response from the proxied server.
    - `proxy_set_header Host $http_host`: This sets the `Host` header to the value of the `$http_host` variable.
    - `proxy_set_header X-Real-IP $remote_addr`: This sets the `X-Real-IP` header to the client’s IP address.
    - `proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for`: This adds the client’s IP address to the `X-Forwarded-For` header.

### Summary
This Nginx configuration sets up a reverse proxy server that:

1. Forwards requests to `/service1/` to the backend servers defined in `service1Upstream`, but only if they are authorized.
2. Handles authorization by forwarding internal requests to `/auth-server/` to the backend servers defined in `authUpstream`.

This setup allows for centralized handling of authentication and proxying of requests to different services based on the request path.