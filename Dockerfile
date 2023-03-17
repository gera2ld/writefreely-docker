FROM alpine AS builder

ARG TARGETARCH

WORKDIR /app

RUN apk add --no-cache curl \
  && curl -Lo /app/writefreely.tar.gz https://github.com/writefreely/writefreely/releases/download/v0.13.1/writefreely_0.13.1_linux_$TARGETARCH.tar.gz \
  && tar zvxf /app/writefreely.tar.gz

FROM alpine

# Install shared dependencies for CGO
RUN apk add --no-cache gcompat
COPY --from=builder /app/writefreely /writefreely
COPY entry-point.sh /writefreely
COPY config.example.ini /writefreely

WORKDIR /writefreely
VOLUME /data
CMD ["/writefreely/entry-point.sh"]
