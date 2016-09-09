#!/bin/sh
# Give some additional time for Selenium server to start properly.
sleep 2
# Navigate to the folder with Behat.
cd /srv
# Run Behat with parameters passed using CMD.
behat $*
# Fix permissions to artifacts folder.
chmod -R 777 /srv/artifacts
