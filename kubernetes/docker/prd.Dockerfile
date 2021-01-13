FROM golang:1.15-buster AS builder

ENV GOPRIVATE=""
ENV GOOS=""
ENV GOARCH=""
ENV CGO_ENABLED=0

# add ca certificates and timezone data files
# hadolint ignore=DL3008
RUN apt-get --yes --no-install-recommends install ca-certificates tzdata \
  && apt-get clean \
  && rm -rf /etc/apt /var/apt

# add unprivileged user
RUN adduser -s /bin/true -u 1000 -D -h /app app \
  && sed -i -r "/^(app|root)/!d" /etc/group /etc/passwd \
  && sed -i -r 's#^(.*):[^:]*$#\1:/sbin/nologin#' /etc/passwd

RUN go build std

WORKDIR /go/src/app/

COPY . /go/src/app/
RUN GIT_TAG="$(git describe --tags --abbrev=0)" \
    go build -trimpath -mod=vendor -ldflags "-X main.buildTag=${GIT_TAG} -w -s -extldflags '-static'" -o /go/bin/api ./cmd/api/ \
    && chmod u=rx,g=,o= /go/bin/api

#
# ---
#

FROM scratch

LABEL org.opencontainers.image.source="https://github.com/ironpeakservices/iron-chart-go"

COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /etc/passwd /etc/group /etc/shadow /etc/
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

COPY --chown=1000 storage/migrations/ /migrations

COPY --from=builder --chown=1000 /go/bin/api /app

USER 1000
EXPOSE 8080
ENTRYPOINT ["/app"]
