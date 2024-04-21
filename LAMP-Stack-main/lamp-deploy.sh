#!/bin/bash

echo "Initiating LAMP Stack installation and set-up"
echo " "

echo "------------------>"
sleep 1
echo "------------------>"
sleep 1
echo "------------------>"
sleep 1
echo " "

# Update package index
echo "Updating repository package index"
sudo apt update
echo "Update Successful"
echo " "
sleep 2

# Install Apache
echo "Installing Apache web server"
sudo apt install -y apache2
echo " "
sleep 2

# Install MySQL
echo "Installing MySQL database"
sudo apt install -y mysql-server
sudo mysql_secure_installation
echo " "
sleep 2

# configure mysql
echo "Configuring MySQL"
sudo mysql -u root -p
CREATE USER 'yekinni'@'localhost' IDENTIFIED BY 'vagrant';
FLUSH PRIVILEGES;
CREATE DATABASE laravel-app;
SHOW DATABASES;
GRANT ALL PRIVILEGES ON laravel-app.* to 'yekinni'@'localhost';
sudo systemctl stop mysql
sudo systemctl restart mysql
echo " "
sleep 2

# Install PHP
echo "Installing PHP"
sudo add-apt-repository ppa:ondrej/php
sudo apt update
#sudo apt install -y php libapache2-mod-php php-mysql php-curl php-gd php-json php-mbstring php-xml php-zip
sudo apt install -y php8.2-curl php8.2-dom php8.2-mbstring php8.2-xml php8.2-mysql zip unzip
echo " "
sleep 2

# Start the apache and mysql services
echo 'Starting the apache and MySQL services'
sudo systemctl restart apache2
#sudo systemctl restart mysql
echo " "
sleep 2

# Output status message
echo "LAMP stack deployment complete."

# Install composer for laravel
cd /usr/bin
curl -sS https://getcomposer.org/installer | sudo php
sudo mv composer.phar composer

# Clone the laravel app repo inside the /var/www/ and get dependencies
cd /var/www/
#sudo git clone https://github.com/laravel/laravel.git
cd laravel
sudo composer install --optimize-autoloader --no-dev

# Update ENV file and generate an encryption key
# cd /var/www/html
sudo cp .env.example .env
php artisan key:generate
sudo nano .env

# set permissions
sudo chown -R www-data storage
sudo chown -R www-data bootstrap/cache

# edit the .env file and define database
#nano .env

# configure apache for laravel
sudo nano /etc/apache2/sites-available/azeezLaravelapp.conf

# activate apache rewrite module and enable website
sudo a2enmod rewrite
sudo a2ensite azeezLaravelapp.conf
sudo apache2ctl -t
sudo systemctl restart apache2




