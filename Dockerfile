FROM ubuntu:xenial

RUN echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu xenial main" \
> /etc/apt/sources.list.d/ondrej-php5-5_6-trusty.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C
RUN apt-get update

RUN apt-get install -y \
 php5.6 \
 php5.6-mcrypt \
 php5.6-curl \
 php5.6-cli \
 php5.6-mysql \
 php5.6-mysqli \
 php5.6-mbstring \
 php5.6-gd \
 php5.6-dom \
 php5.6-intl \
 apache2

RUN echo \
"<VirtualHost *:80>\n \
    DocumentRoot \"/var/www/html/\"\n \
    <Directory \"/var/www/html/\">\n \
        Options FollowSymLinks\n \
        AllowOverride All\n \
        Order allow,deny\n \
        Allow from all\n \
    </Directory>\n \
</VirtualHost>\n" \
> /etc/apache2/sites-available/000-default.conf

RUN sed -i "$a ServerName localhost" /etc/apache2/apache2.conf
RUN sed -i '$a APACHE_SERVER_NAME=localhost' /etc/apache2/envvars

RUN a2enmod rewrite

RUN usermod -u 1000 www-data
RUN usermod -G staff www-data
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]