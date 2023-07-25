build:
	docker build . -t indapublic:php-fpm

push:
	docker push indapublic/php-fpm:latest
