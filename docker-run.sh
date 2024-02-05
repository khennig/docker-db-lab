#!/bin/sh

# Usage: docker-run.sh

POSTGRES_DB=mydatabase
POSTGRES_USER=myuser
POSTGRES_PASSWORD=mypass
POSTGRES_URL=jdbc:postgresql://localhost:5432/$POSTGRES_DB

docker build -t de.erik.lab/docker-db-lab .
docker rm -f docker-db-lab || true
docker run -d -p 5432:5432  \
  --env POSTGRES_DB=$POSTGRES_DB \
  --env POSTGRES_USER=$POSTGRES_USER \
  --env POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
  --name docker-db-lab \
  de.erik.lab/docker-db-lab

mvn clean compile flyway:migrate \
  -Dflyway.url=$POSTGRES_URL \
  -Dflyway.user=$POSTGRES_USER \
  -Dflyway.password=$POSTGRES_PASSWORD

docker commit docker-db-lab de.erik.lab/docker-db-lab
