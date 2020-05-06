# ISLE 8 - Houdini image

Designed to used with:

* The `isle-houdini-connector` container and docker-compose service
* The Drupal 8 site

Based on:

* Official PHP Apache image: [php:7.4.3-apache](https://hub.docker.com/layers/php/library/php/7.4.3-apache/images/sha256-48dde1707d7dca2b701aa230344c58cb8ec5b0ce8e9dbceced65bec5ccd7d1d0?context=explore)

Contains and includes:

* [Composer](https://getcomposer.org/)
* [ImageMagick with JP2 support](https://launchpad.net/~lyrasis/+archive/ubuntu/imagemagick-jp2)
* [Houdini](https://github.com/Islandora/Crayfish/tree/dev/Houdini)

### Running

To run the container, you'll need to bind mount two things:

* A public key from the key pair used to sign and verify JWT tokens at `/opt/keys/public.key`
* A `php.ini` file with output buffering enabled at `/usr/local/etc/php/php.ini`

You'll also want to set two environment variables, which affect configuration of the microservice

* HOUDINI_JWT_ADMIN_TOKEN - An easy to remember token to replace an actual JWT when testing (usually "islandora")
* HOUDINI_LOG_LEVEL - Logging level for the Houdini microservice (DEBUG, INFO, WARN, ERROR, etc...)

`docker run -d -p 8000:8000 -e HOUDINI_JWT_ADMIN_TOKEN=islandora -e HOUDINI_LOG_LEVEL=DEBUG -v /path/to/public.key:/opt/keys/public.key -v /path/to/php.ini:/usr/local/etc/php/php.ini isle-houdini`

### Testing

To test Houdini, you can issue a curl command against it to verify its endpoints are working.  For example, to run `identify` on the Islandora logo:

* curl -H "Authorization: Bearer islandora" -H "Apix-Ldp-Resource: https://islandora.ca/sites/default/files/Islandora.png" idcp.localhost:8000/identify

Note the the `Authorization` header contains the HOUDINI_JWT_ADMIN_TOKEN value after `Bearer`.
