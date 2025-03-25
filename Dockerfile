FROM golang:1.24.1 AS builder

WORKDIR /build

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /app/contagious main.go

FROM debian:12-slim

RUN apt-get update && \
    apt-get install -y tar ca-certificates gnupg curl jq --no-install-recommends && \
    # Import Docker GPG key
    install -m 0755 -d /etc/apt/keyrings && \
    curl --retry 5 -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg && \
    # Add the Docker repository with the correct key ID
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    # Install Docker
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli docker-buildx-plugin containerd.io --no-install-recommends

WORKDIR /app

COPY --from=builder /app/contagious .

RUN cp contagious /usr/local/bin/

ENTRYPOINT ["/app/contagious"]

CMD ["--help"]
