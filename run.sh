#!/bin/sh

# Create function behat () to run behat container with additional options.
behat() {
  docker run -ti --rm --link selenium_chrome -h docker-behat -v $(pwd):/home/behat/data:rw bergil/docker-behat /bin/bash -c "behat $*" ;
}

# Run selenium container.
docker run --restart=always --name=selenium_chrome -d -p 4444:4444 -v /dev/shm:/dev/shm selenium/standalone-chrome:2.52.0

# Run behat container, initialize behat and run tests.
behat --init && behat --format=pretty --out=std --format=cucumber_json --out=std


# Stop and remove selenium container.
docker stop selenium_chrome && docker rm selenium_chrome
