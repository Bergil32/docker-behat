#!/bin/sh

# Section for running tests in Docker environments.
if [ "$DOCKER_TESTING_ENVIRONMENT" -eq "1" ]; then

# If else statement to keep Behat container waiting while site is being built inside php container.
# To run tests you need to pass some parameters to Behat container.
# E.x., docker-compose exec behat /srv/entrypoint.sh "--format=pretty --out=std --format=cucumber_json --out=std".
  if [ -z "$*" ]; then

    # Update composer if $COMPOSER_UPDATE = 1.
    if [ "$COMPOSER_UPDATE" -eq "1" ]; then
        composer update
    fi

    # Foreground command to keep container working.
    tail -f /dev/null

  # Run Behat with parameters passed using CMD.
  else
    bin/behat $*
  fi
fi

# Section for running tests in non-Docker environments.
if [ "$DOCKER_TESTING_ENVIRONMENT" -eq "0" ]; then

  if [ -z "$*" ]; then

    # Foreground command to keep container working.
    tail -f /dev/null
  else

    # Update composer if $COMPOSER_UPDATE = 1.
    if [ "$COMPOSER_UPDATE" -eq "1" ]; then
      composer update
    else

      # Give some additional time for Selenium server to start properly.
      sleep 2
    fi

    # Run Behat with passed parameters.
    bin/behat $*

    # Fix permissions to artifacts folder.
    chmod -R 777 /srv/artifacts
  fi
fi
