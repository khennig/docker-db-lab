#!/bin/sh

# Usage: docker-run.sh

POSTGRES_DB=mydatabase
POSTGRES_USER=myuser
POSTGRES_PASSWORD=mypass
POSTGRES_URL=jdbc:postgresql://localhost:5432/$POSTGRES_DB
CV_RUNTIME=docker

wait_for_postgresql() {
  TRIES=0
  while ! $CV_RUNTIME exec docker-db-lab pg_isready; do
    TRIES=$((TRIES + 1))
    if [ "$TRIES" -ge "10" ]; then
      echo "Stop waiting for PostgreSQL to accept connections"
      exit 1
    fi
    sleep 1
  done
}

$CV_RUNTIME build -t de.erik.lab/docker-db-lab .
$CV_RUNTIME rm -f docker-db-lab || true
$CV_RUNTIME run -d -p 5432:5432  \
  --env POSTGRES_DB=$POSTGRES_DB \
  --env POSTGRES_USER=$POSTGRES_USER \
  --env POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
  --name docker-db-lab \
  de.erik.lab/docker-db-lab

echo "Waiting for PostgreSQL to accept conntections ..."
wait_for_postgresql

mvn clean compile flyway:migrate \
  -Dflyway.url=$POSTGRES_URL \
  -Dflyway.user=$POSTGRES_USER \
  -Dflyway.password=$POSTGRES_PASSWORD

$CV_RUNTIME commit docker-db-lab de.erik.lab/docker-db-lab
