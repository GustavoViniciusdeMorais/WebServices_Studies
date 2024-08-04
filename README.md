# Microservices example with NGINX and Golang

#### NGINX Config
[Details](./nginxConfig.md)
```conf
upstream authUpstream {
    server auth:9090 max_fails=0 fail_timeout=10s;
    keepalive 512;
}

upstream service1Upstream {
    server services1:9091 max_fails=0 fail_timeout=10s;
    keepalive 512;
}

server {
    listen 80;
    listen [::]:80;

    server_name api-gateway.local;

    location /service1/ {
        auth_request /auth-server/validate;
        auth_request_set $auth_status $upstream_status;
        proxy_pass http://service1Upstream/;
    }

    location /auth-server/ {
        internal;
        proxy_pass http://authUpstream/;
        proxy_buffers 8 16k;
        proxy_buffer_size 32k;
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

#### Golang scripts for the services

```go
package main

import (
	"net/http"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

func main() {
	e := echo.New()

	// Middleware to check for a custom token
	e.Use(middleware.KeyAuth(func(key string, c echo.Context) (bool, error) {
		return key == "simple_token", nil
	}))

	// Route to validate the token
	e.GET("/validate", func(c echo.Context) error {
		return c.String(http.StatusOK, "Token valid")
	})

	e.Start(":9090")
}
```

In this script:
- We use `KeyAuth` middleware to check for a token, which is hardcoded as `"simple_token"`.
- The `/validate` endpoint responds with "Token valid" if the token matches.

### Service1 (services1)

This service simply echoes back a message indicating the endpoint was reached.

```go
package main

import (
	"net/http"
	"github.com/labstack/echo/v4"
)

func main() {
	e := echo.New()

	// Route to handle requests to /service1
	e.GET("/service1/*", func(c echo.Context) error {
		return c.String(http.StatusOK, "Service1 endpoint reached")
	})

	e.Start(":9091")
}
```

In this script:
- The `/service1/*` endpoint responds with "Service1 endpoint reached".

Let's start by reviewing the Dockerfile for the `auth` service and then creating a Dockerfile for the `service1` service. After that, we will set up a `docker-compose.yml` file that defines the services, their Docker images, and the common network.

#### Dockerfile for Auth Service

Here is a simple Dockerfile for the `auth` service:<br>
[Details](./goDockerFile.md)
```Dockerfile
FROM golang:1.21-alpine as builder

WORKDIR /app

COPY . .

RUN ls

RUN go mod vendor

RUN go build -o main

FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/main .

EXPOSE 9090

CMD ["./main"]
```

### Dockerfile for Service1

The Dockerfile for the `service1` service will be similar, with adjustments for the binary name:

```Dockerfile
FROM golang:1.21-alpine as builder

WORKDIR /app

COPY . .

RUN go mod vendor

RUN go build -o main

FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/main .

EXPOSE 9091

CMD ["./main"]
```

### Docker-Compose File

The `docker-compose.yml` file will define the services and network, including the Nginx service that ties everything together.

```yaml
version: '3.8'

services:
  auth:
    build:
      context: ./auth
      dockerfile: Dockerfile
    networks:
      - app-network
    ports:
      - "9090:9090"

  service1:
    build:
      context: ./service1
      dockerfile: Dockerfile
    networks:
      - app-network
    ports:
      - "9091:9091"

  nginx:
    image: nginx:latest
    ports:
      - "80:80"
    volumes:
      - ./nginx/default.conf:/etc/nginx/nginx.conf
    networks:
      - app-network

networks:
  app-network:
    driver: bridge
```

### Directory Structure

Assuming the following directory structure:

```
/project-root
  ├── auth
  │   ├── Dockerfile
  │   ├── go.mod
  │   ├── go.sum
  │   └── main.go
  ├── service1
  │   ├── Dockerfile
  │   ├── go.mod
  │   ├── go.sum
  │   └── main.go
  ├── nginx.conf
  └── docker-compose.yml
```

#### Explanation

1. **Dockerfiles**:
   - Each service (`auth` and `service1`) has a corresponding Dockerfile that builds the Go binary and sets it up in a minimal Debian-based image for runtime.
   - The Go modules are downloaded and the app is built in a separate builder stage, which is then copied into a slim image for better efficiency.

2. **docker-compose.yml**:
   - Defines three services: `auth`, `service1`, and `nginx`.
   - Each service is connected to a shared network called `app-network`.
   - The Nginx service uses the `nginx.conf` file from the host directory.

3. **Nginx Configuration**:
   - The `nginx.conf` file is mapped into the Nginx container to route requests to the appropriate Go services.

To bring up the entire stack, navigate to the project root and run:

```bash
docker compose up --build
```

This command will build the Docker images for the services, start the containers, and set up the network. You can access the services via the Nginx reverse proxy.

### 1. Curl Request to Auth Service

This request is intended to check the authentication mechanism. It should include a custom header with the token that the `auth` service expects.

```bash
curl -H "Authorization: simple_token" http://localhost/auth-server/validate
```

**Explanation:**
- `-H "Authorization: simple_token"`: Sets the custom header `Authorization` with the value `simple_token`. This header is checked by the `auth` service to validate the request.
- `http://localhost/auth-server/validate`: Sends a GET request to the `/auth-server/validate` endpoint. This endpoint is mapped to the `auth` service's `/validate` endpoint by Nginx.

### 2. Curl Request to Service1

This request is intended to access the `service1` endpoint via the Nginx reverse proxy. It assumes that the `auth` request is successful.

```bash
curl -H "Authorization: simple_token" http://localhost/service1/
```

**Explanation:**
- `-H "Authorization: simple_token"`: Includes the same token header to pass through the auth request check configured in Nginx.
- `http://localhost/service1/`: Sends a GET request to the `/service1/` endpoint. This is mapped to the `service1` service by Nginx.

### Notes
- The `Authorization` header is used here for simplicity, as the example assumes a basic token-based check in the `auth` service. In a production environment, you might use more complex authentication mechanisms, such as JWTs or OAuth tokens.
- The requests are sent to `http://localhost/` assuming the Docker containers are set up on the local machine and the Nginx reverse proxy is exposed on port 80.
- Make sure the services are running and accessible via Nginx before making these requests.

You can test these requests after running the `docker-compose` setup. The responses will vary depending on the implementation details of the Go services.
