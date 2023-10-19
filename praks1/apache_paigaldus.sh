#!/bin/bash
# Skript kontrollib Apache2 teenuse olemasolu. Puudumisel paigaldab teenuse Apache2.

# Kontrollime Apache2 olemasolu
if dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -q "install ok installed"
then
	# Apache2 on olemas, kuvame staatuse
	echo "Apache2 on juba paigaldatud."
	systemctl start apache2
	systemctl status apache2
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
