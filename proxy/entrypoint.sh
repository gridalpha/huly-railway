#!/bin/sh
# A ${{svc.RAILWAY_PRIVATE_DOMAIN}} reference renders empty until that service
# owns a deployment, which leaves the variable set to a bare ":<port>" and makes
# Caddy bake "http://:3000" as the upstream. Caddy's {$VAR:default} does not
# rescue that, because the variable is set. Repair on the value's shape instead.
set -e

fix() {
	eval "value=\${$1-}"
	case "$value" in
		"" | :*) export "$1=$2" ;;
	esac
}

fix ACCOUNT_HOST account.railway.internal:3000
fix COLLABORATOR_HOST collaborator.railway.internal:3078
fix TRANSACTOR_HOST transactor.railway.internal:3333
fix REKONI_HOST rekoni.railway.internal:4004
fix STATS_HOST stats.railway.internal:4900
fix FRONT_HOST front.railway.internal:8080

caddy validate --config /etc/caddy/Caddyfile --adapter caddyfile
exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
