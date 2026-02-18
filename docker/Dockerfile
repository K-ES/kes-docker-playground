FROM postgres:16

RUN apt-get update && \
    apt-get install -y curl unzip && \
    rm -rf /var/lib/apt/lists/*

# init-скрипт выполнится автоматически при первом старте БД
COPY 01-init.sh /docker-entrypoint-initdb.d/01-init.sh
RUN chmod +x /docker-entrypoint-initdb.d/01-init.sh