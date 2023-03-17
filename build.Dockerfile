# Use alpine:3.16 for node@16 because writefreely is using Webpack 4
FROM alpine:3.16 as builder

ARG REPOSITORY=https://github.com/writefreely/writefreely.git
ARG VERSION=v0.13.2

ENV GOPATH /go
ENV PATH $GOPATH/bin:$PATH
ENV GO111MODULE=on

RUN echo "@community http://dl-cdn.alpinelinux.org/alpine/v3.16/community" >> /etc/apk/repositories && \
    apk add --no-cache nodejs-current npm go make g++ git && \
    go install std && \
    go install -a -v github.com/go-bindata/go-bindata/...@latest && \
    npm install -g less less-plugin-clean-css

RUN mkdir -p /go/src/github.com/writefreely/writefreely/ && \
    git clone $REPOSITORY /go/src/github.com/writefreely/writefreely/ -b $VERSION

WORKDIR /go/src/github.com/writefreely/writefreely/

RUN make build && \
    make ui

RUN mkdir /writefreely && \
    cp -R \
      /go/src/github.com/writefreely/writefreely/templates \
      /go/src/github.com/writefreely/writefreely/static \
      /go/src/github.com/writefreely/writefreely/pages \
      /go/src/github.com/writefreely/writefreely/cmd/writefreely/writefreely \
      /writefreely

FROM alpine

COPY --from=builder /writefreely /writefreely
COPY entry-point.sh /writefreely
COPY config.example.ini /writefreely

WORKDIR /writefreely
VOLUME /data
EXPOSE 8080
CMD ["/writefreely/entry-point.sh"]
