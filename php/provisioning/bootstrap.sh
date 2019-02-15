#!/bin/sh

# DB User
APP_DB_USER=app
APP_DB_PASSWORD=password

# Databases
APP_DB_NAME=db
APP_TEST_DB_NAME=db_test

# Set language
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

# Installation
echo "mysql-server mysql-server/root_password password vagrant" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password vagrant" | debconf-set-selections

# Install necessary packages
sudo apt-get update
apt-get install python-software-properties
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update

# Apache, MySQL, and PHP7.2
sudo apt-get install -y apache2 php7.2 mysql-server
# Apache modules
sudo apt-get install -y libapache2-mod-php7.2 libapache2-mod-fastcgi
# PHP 7.2 extensions
sudo apt-get install -y php7.2-cli php7.2-json php7.2-opcache php7.2-readline php7.2-intl php7.2-xml php7.2-mysql php7.2-fpm php7.2-zip php7.2-gd php7.2-mbstring php-xdebug php-apcu
# Make, NFS (vagrant)
sudo apt-get install -y make

# Install Composer (PHP)
curl -s https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Install Node.js 8~
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs

# Setup MySQL
if [ ! -f /var/log/databasesetup ];
then
    echo "CREATE USER '$APP_DB_USER'@'%' IDENTIFIED BY '$APP_DB_PASSWORD'" | mysql -uroot -pvagrant
    echo "CREATE DATABASE $APP_DB_NAME DEFAULT CHARACTER SET utf8" | mysql -uroot -pvagrant
    echo "GRANT ALL ON $APP_DB_NAME.* TO '$APP_DB_USER'@'%'" | mysql -uroot -pvagrant
    echo "CREATE DATABASE $APP_TEST_DB_NAME DEFAULT CHARACTER SET utf8" | mysql -uroot -pvagrant
    echo "GRANT ALL ON $APP_TEST_DB_NAME.* TO '$APP_DB_USER'@'%'" | mysql -uroot -pvagrant
    echo "FLUSH PRIVILEGES" | mysql -uroot -pvagrant

    # Disable global address binding
    sed -i 's/bind-address/# bind-address/' /etc/mysql/mysql.conf.d/mysqld.cnf

    service mysql restart

    touch /var/log/databasesetup
fi

# Overwrite the default hosted directory to /vagrant/public
sudo cp /vagrant/provisioning/apache/000-default.conf /etc/apache2/sites-available/000-default.conf

# Enable PHP 7.2 fpm and fast_cgi module.
sudo a2enmod proxy_fcgi
sudo a2enconf php7.2-fpm

# Enable PHP rewrite module
sudo a2enmod rewrite

# Restart Apache 2
sudo service apache2 restart

# Cleanup to reduce disk space
rm -rf /var/lib/apt/lists/*
sudo apt-get clean
