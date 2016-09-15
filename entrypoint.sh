#!/bin/sh
# Loop to keep behat container waiting while site is being built inside php container.
# To run tests you need to pass some behat parameters to behat container.
# E.x., 'docker-compose exec behat ./entrypoint.sh "--format=pretty --out=std"'.
while [ -z "$*" ]
do
  sleep 2
done

# Give some additional time for site to start properly.
sleep 5

# Navigate to the folder with Behat.
cd /srv

# Run Behat with parameters passed using CMD.
behat $*

# Fix permissions to artifacts folder.
chmod -R 777 /srv/artifacts
