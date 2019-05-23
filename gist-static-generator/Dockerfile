FROM golang:1.12 as builder

# Copy local code to the container image.
WORKDIR /go/src/gist-static-generator
COPY main.go .
COPY form.html .

# Build the command inside the container.
# (You may fetch or manage dependencies here,
# either manually or with a tool like "godep".)
RUN CGO_ENABLED=0 GOOS=linux go build -v -o gist-static-generator

# Use a Docker multi-stage build to create a lean production image.
# https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
FROM alpine
RUN apk add --no-cache ca-certificates

# Copy the binary to the production image from the builder stage.
COPY --from=builder /go/src/gist-static-generator/gist-static-generator /gist-static-generator
COPY --from=builder /go/src/gist-static-generator/form.html .

# Run the web service on container startup.
CMD ["/gist-static-generator"]
