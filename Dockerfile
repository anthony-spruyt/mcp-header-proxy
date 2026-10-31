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

FROM gcr.io/distroless/static:nonroot@sha256:18f4cc26c9ffa7f20a359298be7deadac5c607c8e03a02b8119f1a5fc2f82c99
COPY --from=builder /mcp-header-proxy /mcp-header-proxy
USER 65534:65534
HEALTHCHECK NONE
ENTRYPOINT ["/mcp-header-proxy"]
