ARG PHP_VERSION

FROM php:${PHP_VERSION}-cli-alpine as dependencies

RUN apk add --update --no-cache \
    coreutils

RUN echo "$(curl -sS https://composer.github.io/installer.sig) -" > composer-setup.php.sig \
    && curl -sS https://getcomposer.org/installer | tee composer-setup.php | sha384sum -c composer-setup.php.sig \
    && php composer-setup.php && rm composer-setup.php* \
    && chmod +x composer.phar && mv composer.phar /usr/bin/composer

ARG PHP_VERSION

FROM php:${PHP_VERSION}-fpm-alpine

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions amqp intl mysqli opcache pcntl pdo pdo_mysql phar redis xsl zip

RUN curl -1sLf "https://dl.cloudsmith.io/public/symfony/stable/setup.alpine.sh" | sh && \
    apk add symfony-cli

COPY --from=dependencies /usr/bin/composer /usr/bin/composer

CMD ["php-fpm", "-F"]

EXPOSE 9001
