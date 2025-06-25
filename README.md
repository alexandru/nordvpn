# NordVPN Docker image

This is just a simple Docker image that starts NordVPN, created for my own needs.

```
docker run \
    --cap-add=NET_ADMIN \
    --cap-add=NET_RAW \
    -e NORDVPN_TOKEN="..." \
    -e NORDVPN_MESHNET=1 \
    --device /dev/net/tun \
    --rm \
    -it ghcr.io/alexandru/nordvpn:latest 
```

Example `docker-compose.yml`:

```yaml
version: '3.8'
services:
  nordvpn:
    image: ghcr.io/alexandru/nordvpn:latest
    cap_add:
      - NET_ADMIN
      - NET_RAW
    environment:
      - NORDVPN_TOKEN=... # your token here
      - NORDVPN_MESHNET=1
    devices:
      - /dev/net/tun
    stdin_open: true
    tty: true
    restart: unless-stopped
```

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
