#!/bin/bash
# Skript paigaldab Wordpressi, sealjuures loob MySQL andmebaasi ja konfigureerib Wordpressi konfiguratsioonifaili.

# Loome andmebaasi, kasutaja ja anname talle kõik õigused.
echo "Loon andmebaasi wpdatabase, sealhulgas kasutaja 'wpuser' parooliga 'qwerty'"
mysql --user="root" --password="qwerty" --execute="create database wpdatabase;
CREATE USER wpuser@localhost IDENTIFIED BY 'qwerty';
GRANT ALL PRIVILEGES ON wpdatabase.* to wpuser@localhost;
FLUSH PRIVILEGES;
EXIT"

# Laeme Wordpressi alla ja pakime lahti
echo "Paigaldan Wordpressi..."
wget -P /var/www/html https://wordpress.org/latest.tar.gz
tar xzvf /var/www/html/latest.tar.gz -C /var/www/html
rm /var/www/html/latest.tar.gz
chown -R www-data:www-data /var/www/wordpress

# Paigaldame konfiguratsioonifaili
cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php

echo "Konfigureerin andmebaasi..."
# Lisame konfiguratsioonifaili andmebaasi andmed
sed -i "s/database_name_here/wpdatabase/g" /var/www/html/wordpress/wp-config.php
sed -i "s/username_here/wpuser/g" /var/www/html/wordpress/wp-config.php
sed -i "s/password_here/qwerty/g" /var/www/html/wordpress/wp-config.php

echo "Muudan Wordpress lehe kataloogi peamiseks kataloogiks..."
sed -i 's/\/var\/www\/html/\/var\/www\/html\/wordpress/g' /etc/apache2/sites-available/000-default.conf
systemctl restart apache2

echo "Wordpress edukalt paigaldatud!"
