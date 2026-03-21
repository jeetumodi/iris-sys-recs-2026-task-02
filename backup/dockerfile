FROM debian:bullseye-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends default-mysql-client tar gzip coreutils bash && \
    rm -rf /var/lib/apt/lists/*

COPY backup.sh /backup.sh
RUN chmod +x /backup.sh

CMD ["/backup.sh"]