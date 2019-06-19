FROM golang:1.12.6-alpine3.9 AS hugobuilder
MAINTAINER senare@gmail.com

ENV HUGO_VERSION=0.44 \
    CGO_ENABLED=0 \
    GOOS=linux

RUN \
  apk add --update --no-cache git musl-dev && \
  git clone https://github.com/gohugoio/hugo.git $GOPATH/src/github.com/gohugoio/hugo && \
  cd ${GOPATH:-$HOME/go}/src/github.com/gohugoio/hugo && \
  git checkout v$HUGO_VERSION && \
  go get github.com/golang/dep/cmd/dep && \
  dep ensure -vendor-only && \
  go install -ldflags '-s -w'

FROM scratch
COPY --from=hugobuilder /go/bin/hugo /hugo

VOLUME /src
WORKDIR /src

ENTRYPOINT ["/hugo"]
CMD ["--help"]
