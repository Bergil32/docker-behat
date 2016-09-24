#!/bin/sh

# Section to keep container working in detached mode.
if [ -z "$*" ]; then

  # Update composer if $DOCKER_TESTING_ENVIRONMENT = 1 and $COMPOSER_UPDATE = 1.
  if [ "$DOCKER_TESTING_ENVIRONMENT" -eq "1" ] && [ "$COMPOSER_UPDATE" -eq "1" ]; then
    composer update
  fi

  # Foreground command to keep container working.
  tail -f /dev/null

# Section to run tests.
else

  # Section for running tests in Docker environments.
  if [ "$DOCKER_TESTING_ENVIRONMENT" -eq "1" ]; then

    # To run tests you need to pass some parameters to Behat container.
    # E.x., docker-compose exec behat /srv/entrypoint.sh "--format=pretty --out=std --format=cucumber_json --out=std".
    # Run Behat with parameters passed using CMD.
    bin/behat $*
  fi

  # Section for running tests in non-Docker environments.
  if [ "$DOCKER_TESTING_ENVIRONMENT" -eq "0" ]; then

    # Update composer if $COMPOSER_UPDATE = 1.
    if [ "$COMPOSER_UPDATE" -eq "1" ]; then
      composer update
    else

      # Give some additional time for Selenium server to start properly.
      sleep 2
    fi

    # Run Behat with passed parameters.
    bin/behat $*
  fi

  # Fix permissions to artifacts folder.
  chmod -R 777 /srv/artifacts
fi
