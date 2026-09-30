# xray-knife-sort

An automated delay benchmark tool of sub list.

## Deployment (Podman Quadlet)

Create `~/.config/containers/systemd/v2raya-subcleaner.container`:

```ini
[Unit]
Description=xray-knife sort subs
After=network-online.target

[Container]
Image=ghcr.io/biocoderh/xray-knife-sort:latest
ContainerName=xray-knife-sort
AutoUpdate=registry
HostName=%H
Timezone=local
PublishPort=21170:21170
Volume=xray-knife-sort-data:/var/www:Z
Environment=PORT=21170
Environment=THREADS=50
Environment=UPDATE_INTERVAL=1h
Environment=SOURCE_URL=https://raw.githubusercontent.com/whoahaow/rjsxrd/refs/heads/main/githubmirror/bypass/bypass-all.txt

[Service]
Restart=on-failure
TimeoutStartSec=300

[Install]
WantedBy=default.target
```

Reload and start:
```bash
systemctl --user daemon-reload
systemctl --user start v2raya-subcleaner
```

## Environment Variables

| Variable | Default | Description |
|---|---|---|
| `PORT` | `21170` | Port for the built-in HTTP server |
| `THREADS` | `50` | Number of threads |
| `UPDATE_INTERVAL` | `1h` | Update interval (sleep NUMBER\[SUFFIX\]) |
| `SOURCE_URL` | https://raw.githubusercontent.com/whoahaow/rjsxrd/refs/heads/main/githubmirror/bypass/bypass-all.txt | Remote subscription URL to fetch |
