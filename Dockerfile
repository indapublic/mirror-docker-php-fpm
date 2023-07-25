FROM php:8.1-fpm-alpine

MAINTAINER indapublic <mail@indapublic.com>

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions amqp intl mysqli opcache pdo pdo_mysql phar redis xsl zip

RUN apk add --update --no-cache \
    coreutils \
    make \
    curl \
    git

RUN echo "$(curl -sS https://composer.github.io/installer.sig) -" > composer-setup.php.sig \
    && curl -sS https://getcomposer.org/installer | tee composer-setup.php | sha384sum -c composer-setup.php.sig \
    && php composer-setup.php && rm composer-setup.php* \
    && chmod +x composer.phar && mv composer.phar /usr/bin/composer

RUN apk del coreutils make

RUN curl -1sLf "https://dl.cloudsmith.io/public/symfony/stable/setup.alpine.sh" | sh
RUN apk add symfony-cli

CMD ["php-fpm", "-F"]
