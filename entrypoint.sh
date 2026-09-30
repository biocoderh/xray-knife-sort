#!/bin/bash
set -e

PORT="${PORT:-21170}"
THREADS="${THREADS:-50}"
INTERVAL="${UPDATE_INTERVAL:-1h}"
SUB_URL="${SOURCE_URL:-https://raw.githubusercontent.com/whoahaow/rjsxrd/refs/heads/main/githubmirror/bypass/bypass-all.txt}"

WEB_DIR="/var/www"
mkdir -p "$WEB_DIR"

if [ ! -f "$WEB_DIR/sub.txt" ]; then
    echo "# Initializing proxy list, testing in progress..." > "$WEB_DIR/sub.txt"
fi

python3 -m http.server "$PORT" --directory "$WEB_DIR" >/dev/null 2>&1 &
echo "[+] HTTP server listening on port $PORT. Serving at /sub.txt"

while true; do
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting subscription update..."
    curl -sSL "$SUB_URL" -o /tmp/input.txt

    /app/xray-knife http \
        -f /tmp/input.txt \
        -o /tmp/output.txt \
        --threads $THREADS \
        --speedtest \
        --sort || true

    if [ -s /tmp/output.txt ]; then
        mv -f /tmp/output.txt "$WEB_DIR/sub.txt"
    fi

    rm -f /tmp/input.txt /tmp/output.txt

    echo "[+] Sleeping for ${INTERVAL}..."
    sleep "${INTERVAL}"
done
