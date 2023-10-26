#!/bin/bash
# Skript kontrollib mysql-server teenuse olemasolu. Puudumisel paigaldab teenuse mysql-server ja vajalikud lisad.

# Määrame teenuse muutuja
teenus="mysql-server"

# Kontrollime teenuse olemasolu
if dpkg-query -W -f='${Status}' $teenus 2>/dev/null | grep -q "install ok installed"
then
	# Kui teenus on olemas, kuvame olemasolu
	echo "$teenus on juba paigaldatud."
	mysql
else
	# Kui teenust pole, siis paigaldame
	echo "$teenus pole paigaldatud. Paigaldan $teenus ja vajalikud lisad..."

	# Alustame MySQLi repository lisamisest
	apt update
	apt install gnupg -y
	wget https://dev.mysql.com/get/mysql-apt-config_0.8.27-1_all.deb -P /tmp
	apt install /tmp/mysql-apt-config* -y

	# Paigaldame mysql-serveri
	apt update
	apt install $teenus -y

	# Kontrollime õnnestumist
	if dpkg-query -W -f='${Status}' $teenus 2>/dev/null | grep -q "install ok installed"
	then
		echo "$teenus on edukalt paigaldatud."
		# Nüüd seadistus: saab kasutada mysql'i käsku ilma kasutaja ja parooli täpsustamata
		touch $HOME/.my.cnf
		echo "[client]" >> $HOME/.my.cnf
		echo "host = localhost" >> $HOME/.my.cnf
		echo "user = root" >> $HOME/.my.cnf
		echo "password = qwerty" >> $HOME/.my.cnf
	else
		echo "$teenus paigaldamine ebaõnnestus."
		exit
	fi
fi
