# WebDAV Media Share

A lightweight WebDAV server built with Docker and Nginx for sharing media files.

## Features

- WebDAV protocol support for file sharing
- Optional authentication with username/password
- Web browser access with directory listing
- Docker-based deployment
- Supports file upload, download, and management operations
- **Automatic SSL/TLS encryption** with self-signed certificates
- Simultaneous HTTP and HTTPS support

## Quick Start

1. Create environment variables:
   ```bash
   cp .env.example .env
   # Edit .env with your USERNAME and PASSWORD
   ```

2. Run with Docker Compose:
   ```bash
   docker-compose up -d
   ```

3. Access your files:
   - HTTP: `http://192.168.1.43:8080`
   - HTTPS: `https://192.168.1.43:8088` (accepts self-signed certificate)

## Configuration

- **HTTP Port**: 8080 (mapped to container port 80)
- **HTTPS Port**: 8088 (mapped to container port 443)
- **Data Directory**: `/home/stfu/Torrents` (mounted to `/media/data` in container)
- **Authentication**: Set `USERNAME` and `PASSWORD` environment variables
- **No Auth Mode**: Leave `USERNAME` and `PASSWORD` empty for public access
- **SSL Certificates**: Automatically generated self-signed certificates on container startup

## Environment Variables

- `USERNAME`: WebDAV username (optional)
- `PASSWORD`: WebDAV password (optional)

## WebDAV Clients

Connect using any WebDAV client with one of the server URLs:
- HTTP: `http://192.168.1.43:8089`
- HTTPS: `https://192.168.1.43:8088` (accepts self-signed certificate)

## SSL/TLS Security

The server automatically generates self-signed SSL certificates on startup for HTTPS access. This provides encrypted communication but browsers will show a security warning since the certificate is not signed by a trusted Certificate Authority.

- **Certificate Location**: `/etc/nginx/certs/selfsigned.crt` and `/etc/nginx/certs/selfsigned.key` (inside container)
- **Certificate Validity**: 10 years
- **Regeneration**: Certificates are regenerated on each container restart