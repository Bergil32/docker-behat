Environment for running Behat tests.
============

[![](https://images.microbadger.com/badges/version/bergil/docker-behat.svg)](https://microbadger.com/images/bergil/docker-behat) [![](https://images.microbadger.com/badges/image/bergil/docker-behat.svg)](https://microbadger.com/images/bergil/docker-behat)


This image is based on [Alpine Linux](https://hub.docker.com/_/alpine/) with PHP7 and could be used to test Docker and non-Docker websites. 

This image includes (composer update is possible):

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

Also, it uses official [selenium/standalone-chrome](https://github.com/SeleniumHQ/docker-selenium) image.

### Prerequirements

* Clone a repository.
```
git clone https://github.com/Bergil32/behat.git
```
* Put your custom contexts into "features/bootstrap/" folder if needed.

* Configure behat.yml for your custom contexts.

* Put your tests into "features/" folder.

* Configure volumes in docker-compose.behat.yml.

### Non-docker websites

* Set base URL in behat.yml for testing site. 

E.x.
```
base_url: 'https://en.wikipedia.org'
```

* Run test.sh script to run tests.
```
sh test.sh
```
* To stop and remove containers use
```
docker-compose -f docker-compose.behat.yml down 
```

### Docker websites

* Configure base URL in behat.yml for testing site in following way.

```
base_url: '{https/http}://{web server service name}:{internal port}'
```
E.x.,
```
base_url: 'http://nginx:80'
```

* Additionally for Drupal 8 add the following line into your settings.php.

E.x.,
```
$settings['trusted_host_patterns'][] = '^nginx$';
``` 
It is needed to grant access to you site for GouteDriver/Selenium server through Nginx container.
 
Change Nginx to your web server service name if needed.

* In order to up testing environment
```
docker-compose -f docker-compose.yml -f docker-compose.behat.yml up -d
```
For additional information read about [extending services and Compose files](https://docs.docker.com/compose/extends/).

* In order to run tests, after environment up commands and all site building command on other containers run the following command .
```
docker-compose -f docker-compose.yml -f docker-compose.behat.yml exec behat /srv/entrypoint.sh "{behat options}"
```
Notice that you must add at least one option to run tests.

### Composer update

#### In order to update composer before running tests do the following

* Set COMPOSER_UPDATE variable to 1
```
COMPOSER_UPDATE: 1
```
* Mount composer.json on your host machine as /srv/composer.json.

```
- {some path}/composer.json:/srv/composer.json
```

### Using API methods of the Drupal extension for Behat.

* Mount folder with drupal on your host machine as /drupal.

E.x.,
```
- {some path}/drupal8:/drupal
```

* If you don't want to use API methods of the Drupal extension for Behat you must comment or delete following lines in behat.yml
```
api_driver: drupal
drush:
  root: /drupal
drupal:
  drupal_root: /drupal
```

### Artifacts

* Reports and text files with information about screenshots are saved in artifacts/ folder.

* Screenshots will be uploaded to [https://wsend.net/](https://wsend.net/).

##### For more information read entrypoint.sh, docker-compose.behat.yml and test.sh. Nearly each code and config line has comments.

#### Additional thanks to [Serge Skripchuk](https://www.drupal.org/u/idtarzanych) for his help.
