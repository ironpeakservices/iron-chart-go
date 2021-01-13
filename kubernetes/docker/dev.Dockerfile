FROM golang:1.15-buster AS builder

LABEL org.opencontainers.image.source="https://github.com/ironpeakservices/iron-chart-go"

ENV GOCACHE="/cache"
ENV XDG_CONFIG_HOME="/cache/delve/"
ENV GOPRIVATE=""
ENV GOOS=""
ENV GOARCH=""
ENV CGO_ENABLED=0

# add unprivileged user
RUN adduser -s /bin/true -u 1000 -D -h /app app \
  && sed -i -r "/^(app|root)/!d" /etc/group /etc/passwd \
  && sed -i -r 's#^(.*):[^:]*$#\1:/sbin/nologin#' /etc/passwd

# add ca certificates and timezone data files
# hadolint ignore=DL3008
RUN apt-get --yes --no-install-recommends install ca-certificates tzdata git gcc libc-dev \
    && go get github.com/cespare/reflex \
    && go get github.com/go-delve/delve/cmd/dlv \
    && apt-get clean \
    && rm -rf /etc/apt /var/apt

RUN go build std

ENV TMPDIR="/cache"
WORKDIR /go/src/app

EXPOSE 8080 40000
USER 1000
ENTRYPOINT ["/go/bin/reflex", "--sequential", "--config=/go/src/app/kubernetes/docker/reflex.conf"]
