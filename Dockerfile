FROM isle-crayfish-base:latest

## Imagick 
# @see: https://launchpad.net/~lyrasis/+archive/ubuntu/imagemagick-jp2 

ENV IMAGEMAGICK_REPO=http://ppa.launchpad.net/lyrasis/imagemagick-jp2/ubuntu \
    IMAGEMAGICK_GPG_KEY=C806C0C35327CC80F2B4A41ED2B749E9FF0FA317

RUN echo deb $IMAGEMAGICK_REPO bionic main >> /etc/apt/sources.list && \
    echo deb-src $IMAGEMAGICK_REPO bionic main >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $IMAGEMAGICK_GPG_KEY && \
    IMAGEMAGICK_PACKS="imagemagick" && \
    apt-get update && \
    apt-get install --no-install-recommends -y $IMAGEMAGICK_PACKS && \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    sed -i "/<policymap>/a \ \ <policy domain=\"coder\" rights=\"read|write\" pattern=\"PDF\" \/>/" /etc/ImageMagick-6/policy.xml

COPY rootfs /

# Composer & Houdini
# @see: Composer https://github.com/composer/getcomposer.org/commits/master (replace hash below with most recent hash)
# @see: Houdini https://github.com/Islandora/Crayfish

ENV PATH=$PATH:$HOME/.composer/vendor/bin \
    COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HASH=${COMPOSER_HASH:-b9cc694e39b669376d7a033fb348324b945bce05} \
    HOUDINI_BRANCH=dev

RUN curl https://raw.githubusercontent.com/composer/getcomposer.org/$COMPOSER_HASH/web/installer --output composer-setup.php --silent && \
    php composer-setup.php --filename=composer --install-dir=/usr/local/bin && \
    rm composer-setup.php && \
    mkdir -p /opt/crayfish && \
    git clone -b $HOUDINI_BRANCH https://github.com/Islandora/Crayfish.git /opt/crayfish && \
    composer install -d /opt/crayfish/Houdini && \
    chown -Rv www-data:www-data /opt/crayfish && \
    mkdir /var/log/islandora && \
    chown www-data:www-data /var/log/islandora && \
    a2dissite 000-default && \
    #echo "ServerName localhost" | tee /etc/apache2/conf-available/servername.conf && \
    #a2enconf servername && \
    a2enmod rewrite deflate headers expires proxy proxy_http proxy_html proxy_connect remoteip xml2enc cache_disk

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="ISLE 8 Houdini Image" \
      org.label-schema.description="ISLE 8 Houdini" \
      org.label-schema.url="https://islandora.ca" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/Islandora-Devops/isle-houdini" \
      org.label-schema.vendor="Islandora Devops" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

WORKDIR /opt/crayfish/Houdini/
