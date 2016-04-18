FROM php:7-fpm
MAINTAINER Steve Lo <info@sd.idv.tw>

RUN DEBIAN_FRONTEND=noninteractive ;\
	apt-get update && \
	apt-get install --assume-yes \
		git-core \
		bzip2 \
		nginx \
		libaio-dev \
		wget \
		unzip \
	&& rm -rf /var/lib/apt/lists/*

RUN echo "Asia/Taipei" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

# php exceptions
RUN apt-get update && apt-get install -y \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libmcrypt-dev \
		libpng12-dev \
		libpq5 \
		libpq-dev \
		libsqlite3-dev \
		libcurl4-openssl-dev \
		libicu-dev \
	&& docker-php-ext-install iconv mcrypt zip pdo pdo_pgsql pdo_sqlite pgsql pdo_mysql intl curl mbstring \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install gd \
	&& apt-get remove -y \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libmcrypt-dev \
		libpng12-dev \
		libpq-dev \
		libsqlite3-dev \
		libcurl4-openssl-dev \
		libicu-dev \
	&& rm -rf /var/lib/apt/lists/* \
	&& pecl install apcu  \
	&& export VERSION=`php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;"` \
	&& chown -R www-data:www-data /var/www \
	&& chmod -R 744 /var/www

ADD apcu.ini opcache.ini $PHP_INI_DIR/conf.d/

ADD nginx.conf nginx-app.conf /etc/nginx/


ADD php-fpm.conf /usr/local/etc/
ADD index.php /var/www/

ADD bootstrap-nginx.sh /usr/local/bin/

EXPOSE 80

ENTRYPOINT  ["bootstrap-nginx.sh"]
