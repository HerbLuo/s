#!/bin/sh
/usr/bin/glider -listen :22332 &
echo "http/socks5 proxy server: $(hostname -i):22332"
exec "$@"
