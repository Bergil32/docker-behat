#!/bin/sh

# Create function behat () to run behat container with additional options.
behat() {
  docker run -ti --rm --link selenium_chrome  -h docker-behat -v $(pwd):/home/behat/data:rw bergil/docker-behat /bin/bash -c "behat $*" docker cp docker-behat:/home/behat/build/tests/report.json $(pwd)/build/tests ;
}

# Run selenium container.
docker run --restart=always --name=selenium_chrome -d -p 4444:4444 -v /dev/shm:/dev/shm selenium/standalone-chrome:2.52.0

# Run behat container, initialize behat and run tests.
behat --init && behat -f cucumber_json && docker cp docker-behat:/home/behat/report.json report.json


# Stop and remove selenium container.
docker stop selenium_chrome && docker rm selenium_chrome
