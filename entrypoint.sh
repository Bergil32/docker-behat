#!/bin/sh

if [ "$DOCKER_TESTING_ENVIRONMENT" -eq "1" ]; then

# If else statement to keep behat container waiting while site is being built inside php container.
# To run tests you need to pass some parameters to behat container.
# E.x., docker-compose exec behat /srv/entrypoint.sh "--format=pretty --out=std --format=cucumber_json --out=std".
  if [ -z "$*" ]; then

    # Foreground command to keep container working.
    tail -f /dev/null
  else

    # Run Behat with parameters passed using CMD.
    bin/behat $*
  fi
fi

if [ "$DOCKER_TESTING_ENVIRONMENT" -eq "0" ]; then

  # Give some additional time for Selenium server to start properly.
  sleep 2

  if [ -z "$*" ]; then

    # Set default parameters for behat if no parameters was passed.
    bin/behat --format=pretty --out=std --format=cucumber_json --out=std
  else

    # Run Behat with parameters passed using CMD.
    bin/behat $*
  fi
fi

# Fix permissions to artifacts folder.
chmod -R 777 /srv/artifacts
