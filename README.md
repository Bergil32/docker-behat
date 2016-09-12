Environment for running Behat tests.
============

###### The image and environment architecture are regularly updated. Check for updates.   

[![](https://images.microbadger.com/badges/image/bergil/docker-behat.svg)](https://microbadger.com/images/bergil/docker-behat)


This is tiny behat image based on [Alpine Linux](https://hub.docker.com/_/alpine/) with PHP7.

This image includes:

[Behat](https://packagist.org/packages/behat/behat)

[Mink](https://packagist.org/packages/behat/mink)

[Mink extension](https://packagist.org/packages/behat/mink-extension)

[Mink goutte driver](https://packagist.org/packages/behat/mink-goutte-driver)

[Mink selenium2 driver](https://packagist.org/packages/behat/mink-selenium2-driver)

[Drupal extension](https://packagist.org/packages/drupal/drupal-extension)

[Guzzle](https://packagist.org/packages/guzzlehttp/guzzle)

[PHP Unit](https://packagist.org/packages/phpunit/phpunit)

[Faker](https://packagist.org/packages/fzaninotto/faker)

[PHPspec2-expect](https://packagist.org/packages/bossa/phpspec2-expect)

[Behat cucumber json formatter](https://packagist.org/packages/vanare/behat-cucumber-json-formatter)

Also, run script uses official [selenium/standalone-chrome](https://github.com/SeleniumHQ/docker-selenium) image.

### In order to run tests:
* Clone a repository.
```
git clone https://github.com/Bergil32/docker-behat.git
```

* Put your custom contexts into "features/bootstrap/" folder if needed.

* Configure behat.yml for your custom contexts.

* Put your tests  into "features/" folder and remove Test.feature.


* Run the shell script.
```
sh run.sh
```
* Reports and text files with information about screenshots are saved in artifacts/ folder.

* Screenshots will be uploaded to [https://wsend.net/](https://wsend.net/).

Additional thanks to [Serge Skripchuk](https://www.drupal.org/u/idtarzanych) for his help.
