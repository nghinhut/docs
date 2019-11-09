
---
title: "Effective Docker"
date: 2019-11-02T13:44:05+07:00
image: "/assets/img/Moby-logo.png"
author: "nghinhut@gmail.com (Nghi L. M. Nhựt)"
categories: "Development"
tags: "docker,devops"
draft: false
---

**Docker is a set of platform as a service (PaaS) products that use OS-level virtualization to deliver software in packages called containers.**
<br /><br />
Containers are isolated from one another and bundle their own software, libraries and configuration files; they can communicate with each other through well-defined channels.
All containers are run by a single operating-system kernel and are thus more lightweight than virtual machines.

<!--more-->

<br /><br />
## Docker in Production
Docker can be use in production to create an application "package" avoid problems when working with multiple environments.

<br /><br />
## Docker in Development
Docker can be use to run test environment on all your team member's device.
Usually, your application also run with database, proxy,... in those cases, Docker Compose is a good way to go.

```yaml
# docker-compose.yaml (https://gitlab.com/nghinhut/comstar/blob/master/docker-compose.yaml)
version: "3.7"

services:
  ## DASHBOARD
  dashboard:
    image: bitnami/node:10
    command: sh -c './node_modules/.bin/ng serve --host 0.0.0.0 --port 4200' #--disableHostCheck'
    environment:
      - PORT=4200
    volumes:
      - ./dashboard:/app

  ## CORE
  core:
    image: bitnami/node:10
    command: sh -c 'npm start'
    env_file:
      - .env
    environment:
      - DATABASE_URL=mongodb://root:password123@mongodb-primary:27017/admin
    volumes:
      - ./core:/app

  test-core:
    image: bitnami/node:10
    command: sh -c './node_modules/.bin/jest --watchAll'
    env_file:
      - .env
    environment:
      - DATABASE_URL=mongodb://root:password123@mongodb-primary:27017/admin
    volumes:
      - ./core:/app

  ## Envoy Proxy (require for dashboard)
  envoy:
    image: envoyproxy/envoy-alpine:v1.11.1
    command: sh -c '/usr/local/bin/envoy -c /etc/envoy/envoy.yaml'
    ports:
      - 9901:9901
      - 10000:10000
    volumes:
      - ./core/envoy/envoy.yaml:/etc/envoy/envoy.yaml
    depends_on:
      - core
      - dashboard

  ## gRPC Gateway (optional)
  grpc-gateway:
    build:
      context: ./core/grpc-gateway
      dockerfile: Dockerfile
    command: /app/grpc_gateway --backend=core:5000
    depends_on:
      - core

  ## MongoDB cluster (https://github.com/bitnami/bitnami-docker-mongodb/blob/master/docker-compose-replicaset.yml)
  mongodb-primary:
    image: 'bitnami/mongodb:4.2'
    ports:
      - 27017:27017
    environment:
      - MONGODB_ADVERTISED_HOSTNAME=mongodb-primary
      - MONGODB_REPLICA_SET_MODE=primary
      - MONGODB_ROOT_PASSWORD=password123
      - MONGODB_REPLICA_SET_KEY=replicasetkey123
    volumes:
      - 'mongodb_master_data:/bitnami'

  mongodb-secondary:
    image: 'bitnami/mongodb:4.2'
    depends_on:
      - mongodb-primary
    environment:
      - MONGODB_ADVERTISED_HOSTNAME=mongodb-secondary
      - MONGODB_REPLICA_SET_MODE=secondary
      - MONGODB_PRIMARY_HOST=mongodb-primary
      - MONGODB_PRIMARY_ROOT_PASSWORD=password123
      - MONGODB_REPLICA_SET_KEY=replicasetkey123

  mongodb-arbiter:
    image: 'bitnami/mongodb:4.2'
    depends_on:
      - mongodb-primary
    environment:
      - MONGODB_ADVERTISED_HOSTNAME=mongodb-arbiter
      - MONGODB_REPLICA_SET_MODE=arbiter
      - MONGODB_PRIMARY_HOST=mongodb-primary
      - MONGODB_PRIMARY_ROOT_PASSWORD=password123
      - MONGODB_REPLICA_SET_KEY=replicasetkey123


volumes:
  redis_data:
    driver: local
  mongodb_master_data:
    driver: local

```

