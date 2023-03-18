# Use an official PHP runtime as a parent image
FROM php:8.0-apache

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Copy the Laravel project files to the container
COPY . .

# Install PHP extensions required by Laravel
RUN apt-get update && \
    apt-get install -y libonig-dev libzip-dev unzip && \
    docker-php-ext-install pdo_mysql zip && \
    pecl install redis && \
    docker-php-ext-enable redis

# Install Composer and run `composer install` to install Laravel dependencies
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-dev --no-scripts

# Set the Apache document root to /var/www/html/public
RUN sed -i 's/DocumentRoot\ \/var\/www\/html/DocumentRoot\ \/var\/www\/html\/public/g' /etc/apache2/sites-available/000-default.conf

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Expose port 80 to the Docker host
EXPOSE 80

# Run Apache in the foreground
CMD ["apache2-foreground"]