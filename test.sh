#!/bin/sh

# This script is for easy testing in non-Docker environments.
# Set 'DOCKER_TESTING_ENVIRONMENT: 0' in docker-compose.behat.yml.

# If else statement to set default parameters if no parameters was passed.
if [ -z "$*" ]; then
  BEHAT_PARAMETERS="--format=pretty --out=std --format=cucumber_json --out=std"
else 
  BEHAT_PARAMETERS="$*"
fi

# Start Behat and Selenium server containers
docker-compose -f docker-compose.behat.yml up -d

# Run tests inside Behat container.
docker-compose -f docker-compose.behat.yml exec behat /srv/entrypoint.sh "$BEHAT_PARAMETERS"
