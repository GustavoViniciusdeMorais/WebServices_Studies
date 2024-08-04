### Stage 1: Builder Stage

1. **`FROM golang:1.21-alpine as builder`**
   - This line sets the base image for the first stage of the build process to `golang:1.21-alpine`. This is a lightweight Alpine Linux image with Go version 1.21 installed. The `as builder` part names this stage "builder," which allows us to reference it later.

2. **`WORKDIR /app`**
   - This sets the working directory inside the container to `/app`. All subsequent commands will be run in this directory.

3. **`COPY . .`**
   - This copies all files from the current directory on the host machine to the `/app` directory in the container.

4. **`RUN ls`**
   - This lists the contents of the `/app` directory inside the container. This is usually done for debugging purposes, but it doesn't affect the final image.

5. **`RUN go mod vendor`**
   - This command pulls the dependencies specified in the `go.mod` file into a `vendor` directory, ensuring that the exact versions of dependencies are used.

6. **`RUN go build -o main`**
   - This compiles the Go source code in the current directory and outputs an executable named `main`.

### Stage 2: Final Stage

7. **`FROM alpine:latest`**
   - This sets the base image for the final stage to `alpine:latest`, a minimal Alpine Linux image. This stage will contain only the built executable and necessary files, making the final image smaller and more efficient.

8. **`WORKDIR /app`**
   - This sets the working directory inside the final image to `/app`.

9. **`COPY --from=builder /app/main .`**
   - This copies the `main` executable from the `/app` directory of the "builder" stage into the `/app` directory of the final image.

10. **`EXPOSE 9090`**
    - This indicates that the container will listen on port 9090. This doesn't actually expose the port; it is just a form of documentation. To expose the port, you need to use the `-p` flag when running the container.

11. **`CMD ["./main"]`**
    - This sets the default command to be executed when the container starts. It runs the `main` executable.

In summary, this Dockerfile builds a Go application using a multi-stage build process. The first stage compiles the Go code into a binary, and the second stage creates a minimal image containing only the binary and necessary runtime components. This approach helps in keeping the final Docker image small and secure.