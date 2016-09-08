#!/bin/sh

# Up containers in detached mode and show logs of the Behat container.
docker-compose up -d --force-recreate && docker-compose logs -f behat
# Stop and remove containers.
docker-compose stop && docker-compose rm -f
