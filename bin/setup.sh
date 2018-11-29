#!/bin/bash

if [ -f "./site/web/wp/index.php" ];
then
	echo "WordPress config file found."
else
    echo "WordPress config file not found. Installing..."
    EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)"
	php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
	ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

	if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
	then
		>&2 echo 'ERROR: Invalid installer signature'
		rm composer-setup.php
		exit 1
	fi
    php composer-setup.php --install-dir=bin
    php -r "unlink('composer-setup.php');"
    php ./bin/composer.phar --working-dir=site/ install
fi
