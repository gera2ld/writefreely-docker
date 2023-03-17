# Docker for WriteFreely

## Usage

Create `docker-compose.yml`:

```yaml
version: '3'

services:
  writefreely:
    image: writefreely
    build:
      context: https://github.com/gera2ld/writefreely-docker.git#main
    restart: unless-stopped
    environment:
      - HOST=https://write.example.com
      - USERNAME=writefreely
      - PASSWORD=writefreely
      - SITE_NAME=WriteFreely
      - SITE_DESC=A place to write freely.
    volumes:
      - ./data:/data
```
