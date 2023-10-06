build:
	docker build --build-arg PHP_VERSION=$(PHP_VERSION) . -t indapublic/php-fpm:$(PHP_VERSION)

publish:
	docker push indapublic/php-fpm:$(PHP_VERSION)
