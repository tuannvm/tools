# -- Go Builder Image --
FROM golang:1.11-alpine AS builder

COPY . /go/src/sample-app
WORKDIR /go/src/sample-app

RUN set -ex \
    && go build -v -o "/sample-app"

# -- sample-app Image --
FROM alpine:3.6
RUN set -ex \
  && apk add --no-cache bash ca-certificates git

  COPY --from=builder /sample-app /bin/sample-app
  ENTRYPOINT [ "/bin/sample-app" ]
