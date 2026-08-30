# Railway's edge has no path-based routing, so Huly's nginx path map becomes a
# service of its own. Caddy re-resolves each upstream per request, which matters
# because every backend gets a new address on redeploy.
FROM caddy:2-alpine

COPY proxy/Caddyfile /etc/caddy/Caddyfile
COPY proxy/entrypoint.sh /usr/local/bin/huly-proxy-entrypoint

RUN chmod 0755 /usr/local/bin/huly-proxy-entrypoint \
	&& sh -n /usr/local/bin/huly-proxy-entrypoint \
	&& caddy validate --config /etc/caddy/Caddyfile --adapter caddyfile

CMD ["/usr/local/bin/huly-proxy-entrypoint"]
