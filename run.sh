#!/bin/sh    

behat() { docker run -ti --rm --link selenium_chrome -h docker-behat -v $(pwd):/home/behat/data:rw bergil/docker-behat /bin/bash -c "behat $*" ;}
docker run --restart=always --name=selenium_chrome -d -p 4444:4444 -v /dev/shm:/dev/shm selenium/standalone-chrome:2.52.0
behat --init && behat
docker stop selenium_chrome
docker rm selenium_chrome
