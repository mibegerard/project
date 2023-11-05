# Use an official PHP runtime as the base image
FROM php:7.4-apache

# Set the ServerName for Apache
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Install required extensions and dependencies
RUN apt-get update && apt-get install -y --no-install-recommends locales apt-utils git libicu-dev g++ libpng-dev libxml2-dev libzip-dev libonig-dev libxslt-dev

# Generate locales
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen

# Install Composer
RUN curl -sSk https://getcomposer.org/installer | php -- --disable-tls && \
    mv composer.phar /usr/local/bin/composer

# Configure and install PHP extensions
RUN docker-php-ext-configure intl
RUN docker-php-ext-install pdo pdo_mysql gd opcache intl zip calendar dom mbstring zip gd xsl

# Install and enable APCu
RUN pecl install apcu && docker-php-ext-enable apcu

# Set the working directory
WORKDIR /var/www/

# Copy your Symfony project files into the container (this step may vary depending on your project structure)
COPY . .

# Expose port 80
EXPOSE 80
