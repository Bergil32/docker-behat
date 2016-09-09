#!/bin/sh

# Up containers in detached mode and show logs of the Behat container.
docker-compose up -d && docker-compose logs -f behat
# Stop and remove containers.
docker-compose down