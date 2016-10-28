#!/bin/sh

# To run tests you need to pass some parameters to Behat container.
# E.x., docker-compose exec behat /srv/entrypoint.sh "--format=pretty --out=std".

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

  # Run Behat with parameters passed as command.
  bin/behat $*

  # Fix permissions to artifacts folder.
  chmod -R 777 /srv/artifacts
fi
