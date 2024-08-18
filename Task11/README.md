# Task 11: ELK Stack and Nextcloud-Postgres with Docker Compose

![Static Badge](https://img.shields.io/badge/build-Ubuntu-brightgreen?style=flat&logo=ubuntu&label=Linux&labelColor=Orange&color=red) ![Static Badge](https://img.shields.io/badge/Docker-27.0.3-skyblue?style=flat&logo=docker&label=Docker) ![Static Badge](https://img.shields.io/badge/nginx-1.18.0-grey?style=flat&logo=nginx&label=nginx&labelColor=darkgreen&color=grey) ![Static Badge](https://img.shields.io/badge/Linux-Task11-Orange?style=flat&label=DevOps&labelColor=blue&color=gray)

## Overview

This task involves setting up two distinct Docker Compose environments:

1. **ELK Stack (Elasticsearch, Logstash, Kibana)**: A robust solution for managing and visualizing log data.
2. **Nextcloud-Postgres Stack**: A cloud storage solution using Nextcloud with a PostgreSQL database backend.

Each setup demonstrates how to orchestrate multi-container applications using Docker Compose.

## Part 1: ELK Stack Setup

### Introduction

The ELK stack is a popular solution for centralized logging, log analysis, and visualization. This setup will help you understand how to deploy Elasticsearch, Logstash, and Kibana together using Docker Compose.

### Docker Compose Configuration

The `docker-compose.yml` file defines three services:

- **Elasticsearch**: A distributed search and analytics engine.
- **Logstash**: A server-side data processing pipeline that ingests data, transforms it, and sends it to Elasticsearch.
- **Kibana**: A data visualization and exploration tool for analyzing the data stored in Elasticsearch.

```yaml
version: '3.8'

services:
  elasticsearch:
    image: elasticsearch:7.16.1
    container_name: es
    environment:
      discovery.type: single-node
      ES_JAVA_OPTS: "-Xms512m -Xmx512m"
    ports:
      - "9200:9200"
      - "9300:9300"
    healthcheck:
      test: ["CMD-SHELL", "curl --silent --fail localhost:9200/_cluster/health || exit 1"]
      interval: 10s
      timeout: 10s
      retries: 3
    networks:
      - elastic

  logstash:
    image: logstash:7.16.1
    container_name: log
    environment:
      LS_JAVA_OPTS: "-Xms512m -Xmx512m"
    volumes:
      - ./logstash/pipeline/logstash-nginx.config:/usr/share/logstash/pipeline/logstash-nginx.config
      - ./logstash/nginx.log:/home/nginx.log
    ports:
      - "5000:5000/tcp"
      - "5000:5000/udp"
      - "5044:5044"
      - "9600:9600"
    depends_on:
      - elasticsearch
    networks:
      - elastic
    command: logstash -f /usr/share/logstash/pipeline/logstash-nginx.config

  kibana:
    image: kibana:7.16.1
    container_name: kib
    ports:
      - "5601:5601"
    depends_on:
      - elasticsearch
    networks:
      - elastic

networks:
  elastic:
    driver: bridge
```

### Logstash Configuration

The Logstash configuration file (`logstash-nginx.config`) defines how Logstash processes incoming data. This setup processes logs from an `nginx.log` file:

```plaintext
input {
  file {
    path => "/home/nginx.log"
    start_position => "beginning"
  }
}

filter {
  grok {
    match => { "message" => "%{COMBINEDAPACHELOG}" }
  }
}

output {
  elasticsearch {
    hosts => ["http://es:9200"]
    index => "nginx-logs-%{+YYYY.MM.dd}"
  }
}
```

### Running the ELK Stack

1. **Start the stack**:
   ```bash
   docker-compose up
   ```

2. **Access Kibana**:
   - Open your browser and navigate to `http://localhost:5601`.

### Notes

- Elasticsearch runs as a single node for simplicity.
- Logstash is configured to process `nginx.log`. You can adjust the Logstash configuration to match your specific log format.

## Part 2: Nextcloud-Postgres Stack

### Introduction

This part of the task sets up Nextcloud, a self-hosted cloud storage solution, with a PostgreSQL database backend.

### Docker Compose Configuration

The `docker-compose.yml` file defines two services:

- **Nextcloud (nc)**: The Nextcloud server for cloud storage.
- **PostgreSQL (db)**: The database backend for Nextcloud.

```yaml
version: '3.8'

services:
  nc:
    image: nextcloud:apache
    environment:
      - POSTGRES_HOST=db
      - POSTGRES_PASSWORD=nextcloud
      - POSTGRES_DB=nextcloud
      - POSTGRES_USER=nextcloud
    ports:
      - "88:80"
    restart: always
    volumes:
      - nc_data:/var/www/html

  db:
    image: postgres:alpine
    environment:
      - POSTGRES_PASSWORD=nextcloud
      - POSTGRES_DB=nextcloud
      - POSTGRES_USER=nextcloud
    restart: always
    volumes:
      - db_data:/var/lib/postgresql/data
    expose:
      - "5432"

volumes:
  db_data:
  nc_data:
```

### Running the Nextcloud-Postgres Stack

1. **Start the stack**:
   ```bash
   docker-compose up
   ```

2. **Access Nextcloud**:
   - Open your browser and navigate to `http://localhost:88` to configure your Nextcloud instance.

### Notes

- The Nextcloud service is configured to use PostgreSQL as its database backend.
- Data persistence is handled through Docker volumes.

