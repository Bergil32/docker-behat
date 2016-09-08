#!/bin/sh
# Navigate to the folder with Behat.
cd /srv
# Run Behat with parameters passed using CMD.
behat $*
# Fix permissions to artifacts folder.
chmod -R 777 /srv/artifacts
