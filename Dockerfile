FROM golang:1.24.1 AS builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /app/contagious main.go

FROM debian:12-slim

RUN apt-get update && \
    apt-get install -y ca-certificates tar gnupg curl jq --no-install-recommends

RUN useradd -r -s /bin/false -U -m -d /app appuser

WORKDIR /app

COPY --from=builder /app/contagious .

RUN chown -R appuser:appuser /app

USER appuser

ENTRYPOINT ["/app/contagious"]

CMD ["--help"]
