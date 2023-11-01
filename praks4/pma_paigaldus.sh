#!/bin/bash
# Skript kontrollib phpmyadmin teenuse olemasolu. Puudumisel paigaldab teenuse phpmyadmin.

# Määran teenuse
teenus="phpmyadmin"

# Kontrollime teenuse olemasolu
if dpkg-query -W -f='${Status}' $teenus 2>/dev/null | grep -q "install ok installed"
then
	# Kui teenus on olemas, kuvame olemasolu
	echo "$teenus on juba paigaldatud."
	which $teenus
else
	# Kui teenust pole, siis paigaldame
	echo "$teenus pole paigaldatud. Paigaldan $teenus..."
	apt-get update
	apt install $teenus -y

	# Kontrollime õnnestumist
	if dpkg-query -W -f='${Status}' $teenus 2>/dev/null | grep -q "install ok installed"
	then
		echo "$teenus on edukalt paigaldatud."
	else
		echo "$teenus paigaldamine ebaõnnestus."
		exit
	fi
fi
