# ahls-skriptid
Aine haldustegevuste automatiseerimine tunniülesanded alateemas rakendusserverite automatiseerimine.

Siit repositooriumist leiab nii Bash skriptid kui ka Ansible playbook'id pakettide paigaldamiseks.

## Tingimused
* Playbook'id on testitud vaid **Debian 11** klientmasinatel.
* Klientmasinatel peab olema loodud kasutaja **`user`**.
* Rooti kasutaja parooliks seadistatakse skriptides/playbook'ides **`qwerty`**.
* Kõik skriptid ja playbook'id käivita **`root`** kasutajas!

## Ansible playbook'id (LAMP stack)
  > [!IMPORTANT]
  > LAMP stacki paigaldamiseks paigalda järgnevad playbook'id väljatoodud järjekorras. Wordpress leheküljele saab ligi klientarvuti IP-aadressiga, phpmyadmin leht asub kataloogis `/phpmyadmin`.
  >
  > **Näide**: kui klientmasina IP-aadress on `10.10.10.10`, siis Wordpressile pääseb ligi `10.10.10.10` ja phpmyadmin lehele `10.10.10.10/phpmyadmin`.
  > 
* [__apache2.sh__](https://github.com/kermonurmeoja/ahls-skriptid/blob/master/praks1/apache2.yml) – Paigaldab paketi apache2, loob public_html kataloogi kasutajale user. Lisaks lubab 'userdir' mod-i ning loob useri index.html failile omapärase lehe.
* [__php7.sh__](https://github.com/kermonurmeoja/ahls-skriptid/blob/master/praks2/php7.yml) – Paigaldab paketi php7.4 vajalike lisadega.
* [__mysql.sh__](https://github.com/kermonurmeoja/ahls-skriptid/blob/master/praks3/mysql.yml) – Paigaldab mysql_0.8.26 repositooriumi, paketi mysql-server ja PyMySQL. Lisaks loob kasutajale 'root' login faili ning andmebaasi kasutaja 'root' parooliga 'qwerty'.
* [__pma.sh__](https://github.com/kermonurmeoja/ahls-skriptid/blob/master/praks4/pma.yml) – Paigaldab paketi phpmyadmin ning konfigureerib selle.
* [__wordpress.sh__](https://github.com/kermonurmeoja/ahls-skriptid/blob/master/praks5/wordpress.yml) – Loob andmebaasi 'wpdatabase'. Paigaldab Wordpressi ning konfigureerib konfiguratsioonifailis andmebaasi osa. Lisaks lisab suunamise index.html failist /wordpress kausta.

## Bash skriptid (LAMP stack)
* [__apache_paigaldus.sh__](https://github.com/kermonurmeoja/ahls-skriptid/blob/master/praks1/apache_paigaldus.sh) – Skript kontrollib Apache2 teenuse olemasolu. Puudumisel paigaldab teenuse Apache2.
* [__php_paigaldus.sh__](https://github.com/kermonurmeoja/ahls-skriptid/blob/master/praks2/php_paigaldus.sh) – Skript kontrollib php7.4 teenuse olemasolu. Puudumisel paigaldab teenuse php7.4 ja vajalikud lisad.
* [__mysql_paigaldus.sh__](https://github.com/kermonurmeoja/ahls-skriptid/blob/master/praks3/mysql_paigaldus.sh) – Skript kontrollib mysql-server teenuse olemasolu. Puudumisel paigaldab teenuse mysql-server ja vajalikud lisad.
* [__pma_paigaldus.sh__](https://github.com/kermonurmeoja/ahls-skriptid/blob/master/praks4/pma_paigaldus.sh) – Skript kontrollib phpmyadmin teenuse olemasolu. Puudumisel paigaldab teenuse phpmyadmin ja installeerib vajalikud lisad.
* [__wordpress_paigaldus.sh__](https://github.com/kermonurmeoja/ahls-skriptid/blob/master/praks5/wordpress_paigaldus.sh) – Skript paigaldab Wordpressi, sealjuures loob MySQL andmebaasi ja konfigureerib Wordpressi konfiguratsioonifaili.
* [__lamp.sh__](https://github.com/kermonurmeoja/ahls-skriptid/blob/master/praks6/lamp.sh) – Skript paigaldab apache2, php7.4, mysql-server, phpmyadmin ja Wordpressi. Kui mingi teenus olemas, jätab vahele.
