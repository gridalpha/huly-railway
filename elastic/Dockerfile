# Huly's fulltext service indexes attachments through Elasticsearch's
# ingest-attachment plugin, which the stock image does not ship. Upstream's
# compose installs it at container start; installing it in a build layer keeps
# the boot deterministic and offline.
FROM elasticsearch:7.14.2

USER root

RUN elasticsearch-plugin install --batch ingest-attachment

COPY elastic/elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml

RUN chmod 0644 /usr/share/elasticsearch/config/elasticsearch.yml
