# WebDAV Media Share

A lightweight WebDAV server built with Docker and Nginx for sharing media files.

## Features

- WebDAV protocol support for file sharing
- Optional authentication with username/password
- Web browser access with directory listing
- Docker-based deployment
- Supports file upload, download, and management operations

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

3. Access your files at `http://192.168.1.43:8080`

## Configuration

- **Port**: 8080 (mapped to container port 80)
- **Data Directory**: `/home/stfu/Torrents` (mounted to `/media/data` in container)
- **Authentication**: Set `USERNAME` and `PASSWORD` environment variables
- **No Auth Mode**: Leave `USERNAME` and `PASSWORD` empty for public access

## Environment Variables

- `USERNAME`: WebDAV username (optional)
- `PASSWORD`: WebDAV password (optional)

## WebDAV Clients

Connect using any WebDAV client with the server URL: `http://192.168.1.43:8080`