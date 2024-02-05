# https://github.com/docker-library/postgres/blob/d416768b1a7f03919b9cf0fef6adc9dcad937888/14/bookworm/Dockerfile
FROM postgres:14.10 AS builder

# https://hub.docker.com/_/postgres
# https://github.com/docker-library/postgres/blob/master/14/alpine3.18/Dockerfile
# Store data to the image not a mount point (default)
ENV PGDATA=/var/lib/postgresql/data-local

