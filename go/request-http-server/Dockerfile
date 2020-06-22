FROM golang:1.14-alpine AS builder
WORKDIR /go/src/github.com/tuannvm/request-http-server/
COPY main.go .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /go/src/github.com/tuannvm/request-http-server/app .
CMD ["./app"]
