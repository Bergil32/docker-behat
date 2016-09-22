#!/bin/sh

# If else statement to keep behat container waiting while site is being built inside php container.
# To run tests you need to pass some parameters to behat container.
# E.x., docker-compose exec behat /srv/entrypoint.sh "--format=pretty --out=std --format=cucumber_json --out=std".
if [ -z "$*" ]; then

  # Foreground command to keep container working.
  tail -f /dev/null
else

  # Run Behat with parameters passed using CMD.
  bin/behat $*

  # Fix permissions to artifacts folder.
  chmod -R 777 /srv/artifacts
fi
