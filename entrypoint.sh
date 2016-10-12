#!/bin/sh

# To run tests you need to pass some parameters to Behat container.
# E.x., docker-compose exec behat /srv/entrypoint.sh "--format=pretty --out=std --format=cucumber_json --out=std".

# Section to keep container working in detached mode.
if [ -z "$*" ]; then

  # Update Composer if $COMPOSER_UPDATE = 1.
  if [ "$COMPOSER_UPDATE" -eq "1" ]; then
    # Update Composer and write "1" to tmp file after update finished.
    rm -f /tmp/update_finished && composer update && echo "1" >> /tmp/update_finished
  fi

  # Foreground command to keep container working.
  tail -f /dev/null

# Section to run tests.
else

  # Pause until Composer update will be finished.
  if [ "$COMPOSER_UPDATE" -eq "1" ]; then
    while [  ! -e "/tmp/update_finished" ]; do
      sleep 1
    done
  fi

  # Section for running tests in Docker environments.
  if [ "$DOCKER_TESTING_ENVIRONMENT" -eq "1" ]; then

    # Run Behat with parameters passed using CMD.
    bin/behat $*
  fi

  # Section for running tests in non-Docker environments.
  if [ "$DOCKER_TESTING_ENVIRONMENT" -eq "0" ]; then

    # Give some additional time for Selenium server to start properly.
    sleep 2

    # Run Behat with passed parameters.
    bin/behat $*
  fi

  # Fix permissions to artifacts folder.
  chmod -R 777 /srv/artifacts
fi
