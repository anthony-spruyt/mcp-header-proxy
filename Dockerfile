# renovate: depName=golang datasource=docker
ARG GO_VERSION=1.27.3
FROM golang:${GO_VERSION}-alpine AS builder

ARG VERSION=dev
ARG COMMIT=unknown

WORKDIR /build
COPY go.mod go.sum ./
RUN go mod download
COPY cmd/ cmd/
COPY internal/ internal/
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
  -ldflags="-s -w -X main.version=${VERSION} -X main.commit=${COMMIT}" \
  -o /mcp-header-proxy ./cmd/mcp-header-proxy

FROM gcr.io/distroless/static:nonroot@sha256:25ac8f0c3b2334a9eb05452266bd4697864a8c8ef0ef71e5e6480d7f92868329
COPY --from=builder /mcp-header-proxy /mcp-header-proxy
USER 65534:65534
HEALTHCHECK NONE
ENTRYPOINT ["/mcp-header-proxy"]
