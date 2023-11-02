#!/bin/bash
# Skript paigaldab apache2, php7.4, mysql-server, phpmyadmin ja Wordpressi. Kui mingi teenus olemas, jätab vahele.

# Kontrollime Apache2 olemasolu
if dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -q "install ok installed"
then
	# Apache2 on olemas, kuvame staatuse
	echo "Apache2 on juba paigaldatud. Liigun edasi."
	systemctl start apache2
else
	# Apache2 pole, seega paigaldame
	echo "Apache2 pole paigaldatud. Paigaldan Apache2..."
	apt-get update
	apt-get install apache2 -y

	# Kontrollime õnnestumist
	if dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -q "install ok installed"
	then
		echo "Apache2 on edukalt paigaldatud."
	else
		echo "Apache2 paigaldamine ebaõnnestus."
		exit
	fi
fi

# Kontrollime php7.4 olemasolu
if dpkg-query -W -f='${Status}' php7.4 2>/dev/null | grep -q "install ok installed"
then
	# Kui php7.4 on olemas, kuvame olemasolu
	echo "php7.4 on juba paigaldatud. Liigun edasi."
else
	# Kui php7.4 pole, siis paigaldame
	echo "php7.4 pole paigaldatud. Paigaldan php7.4 ja vajalikud lisad..."
	apt-get update
	apt install php7.4 libapache2-mod-php7.4 php7.4-mysql -y

	# Kontrollime õnnestumist
	if dpkg-query -W -f='${Status}' php7.4 2>/dev/null | grep -q "install ok installed"
	then
		echo "php7.4 on edukalt paigaldatud."
	else
		echo "php7.4 paigaldamine ebaõnnestus."
		exit
	fi
fi

# Kontrollime MySQL olemasolu
if dpkg-query -W -f='${Status}' mysql-server 2>/dev/null | grep -q "install ok installed"
then
	# Kui mysql-server on olemas, kuvame olemasolu
	echo "mysql-server on juba paigaldatud. Liigun edasi."
	# Nüüd seadistus: saab kasutada mysql'i käsku ilma kasutaja ja parooli täpsustamata
		touch $HOME/.my.cnf
		echo "[client]" >> $HOME/.my.cnf
		echo "host = localhost" >> $HOME/.my.cnf
		echo "user = root" >> $HOME/.my.cnf
		echo "password = qwerty" >> $HOME/.my.cnf
else
	# Kui mysql-server pole, siis paigaldame
	echo "mysql-server pole paigaldatud. Paigaldan mysql-server ja vajalikud lisad..."

	# Alustame MySQLi repository lisamisest
	apt update
	apt install gnupg -y
	wget https://dev.mysql.com/get/mysql-apt-config_0.8.27-1_all.deb -P /tmp
	apt install /tmp/mysql-apt-config* -y

	# Paigaldame mysql-serveri
	apt update
	apt install mysql-server -y

	# Kontrollime õnnestumist
	if dpkg-query -W -f='${Status}' mysql-server 2>/dev/null | grep -q "install ok installed"
	then
		echo "mysql-server on edukalt paigaldatud."
		# Nüüd seadistus: saab kasutada mysql'i käsku ilma kasutaja ja parooli täpsustamata
		touch $HOME/.my.cnf
		echo "[client]" >> $HOME/.my.cnf
		echo "host = localhost" >> $HOME/.my.cnf
		echo "user = root" >> $HOME/.my.cnf
		echo "password = qwerty" >> $HOME/.my.cnf
	else
		echo "mysql-server paigaldamine ebaõnnestus."
		exit
	fi
fi

# Kontrollime phpmyadmin olemasolu
if dpkg-query -W -f='${Status}' phpmyadmin 2>/dev/null | grep -q "install ok installed"
then
	# Kui teenus on olemas, kuvame olemasolu
	echo "phpmyadmin on juba paigaldatud. Liigun edasi."
else
	# Kui teenust pole, siis paigaldame
	echo "phpmyadmin pole paigaldatud. Paigaldan phpmyadmin..."
	apt-get update
	apt install phpmyadmin -y

	# Kontrollime õnnestumist
	if dpkg-query -W -f='${Status}' phpmyadmin 2>/dev/null | grep -q "install ok installed"
	then
		echo "phpmyadmin on edukalt paigaldatud."
	else
		echo "phpmyadmin paigaldamine ebaõnnestus."
		exit
	fi
fi

# Liigume edasi Wordpressi paigaldamise juurde
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
