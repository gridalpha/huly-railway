# huly-railway

Deployment images for running [Huly](https://github.com/hcengineering/platform)
on [Railway](https://railway.com). Everything else in the stack runs upstream's
published `hardcoreeng/*` images unchanged; only these two roles need a layer of
their own.

| Directory | Service | Why it is not the stock image |
|---|---|---|
| `proxy/` | public entrypoint | Railway's edge has no path-based routing, so Huly's `nginx` path map (`/_accounts`, `/_transactor`, `/_collaborator`, `/_rekoni`, `/_stats`, `/<jwt>`) becomes a Caddy service. Caddy re-resolves upstreams per request, so a backend redeploy does not strand a cached address. |
| `elastic/` | full-text index | Adds the `ingest-attachment` plugin at build time and binds `::`, since Railway's private network routes IPv6 between services. |

Select the image with `RAILWAY_DOCKERFILE_PATH=proxy/Dockerfile` or
`elastic/Dockerfile`; both build from the repository root.

## Configuration

`proxy/` reads one variable per upstream — `ACCOUNT_HOST`, `COLLABORATOR_HOST`,
`TRANSACTOR_HOST`, `REKONI_HOST`, `STATS_HOST`, `FRONT_HOST` — each a
`host:port`, plus `PORT` and `MAX_UPLOAD_SIZE`. Every one has a working default,
and the entrypoint repairs a value that arrived as a bare `:<port>`, which is
what a `${{service.RAILWAY_PRIVATE_DOMAIN}}` reference renders to before that
service owns its first deployment.

`elastic/` is configured entirely by `elastic/elasticsearch.yml` plus
`ES_JAVA_OPTS`.

## Licence

Huly is published by Hardcore Engineering Inc. under the Eclipse Public
License 2.0. This repository contains only deployment configuration.
