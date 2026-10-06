# mcp-header-proxy

Reverse proxy that forwards MCP headers from an HTTP request into the JSON-RPC body before passing it upstream. Deployed as a sidecar alongside n8n, whose MCP client trigger reads the values from the body rather than the headers.

Streaming responses are flushed immediately (`FlushInterval: -1`) so SSE streams are not buffered, and the write deadline is disabled for the same reason.

## Configuration

| Variable       | Default                 | Purpose                         |
| -------------- | ----------------------- | ------------------------------- |
| `LISTEN_ADDR`  | `:8080`                 | Address the proxy binds to      |
| `UPSTREAM_URL` | `http://localhost:5678` | Upstream the request is sent to |

`GET /healthz` returns `ok` and is used for probes.

## Layout

- `cmd/mcp-header-proxy`: entrypoint and configuration
- `internal/proxy`: the reverse proxy and header injection

```bash
go test -race ./...
golangci-lint run
```

## Releases

release-please opens a release PR from conventional commits. Merging it tags `vX.Y.Z` and creates a draft release. The image `ghcr.io/anthony-spruyt/mcp-header-proxy` is then built from the tag and pushed with an SBOM and provenance. The release is published only after the push succeeds.

If the image job fails, the release stays a draft. Fix the cause, then run the **Rebuild Release** workflow with the version.

Releases up to 0.0.14 were cut from [spruyt-labs](https://github.com/anthony-spruyt/spruyt-labs) as `mcp-header-proxy/vX.Y.Z`.
