#!/bin/bash
# Skript kontrollib php7.4 teenuse olemasolu. Puudumisel paigaldab teenuse php7.4 ja vajalikud lisad.

# Määran teenuse
teenus="php7.4"

# Kontrollime teenuse olemasolu
if dpkg-query -W -f='${Status}' $teenus 2>/dev/null | grep -q "install ok installed"
then
	# Kui teenus on olemas, kuvame olemasolu
	echo "$teenus on juba paigaldatud."
	which $teenus
else
	# Kui teenust pole, siis paigaldame
	echo "$teenus pole paigaldatud. Paigaldan $teenus ja vajalikud lisad..."
	apt-get update
	apt install $teenus libapache2-mod-php7.4 php7.4-mysql -y

	# Kontrollime õnnestumist
	if dpkg-query -W -f='${Status}' $teenus 2>/dev/null | grep -q "install ok installed"
	then
		echo "$teenus on edukalt paigaldatud."
	else
		echo "$teenus paigaldamine ebaõnnestus."
		exit
	fi
fi
