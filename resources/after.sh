#!/bin/sh

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.
#
# If you have user-specific configurations you would like
# to apply, you may also create user-customizations.sh,
# which will be run after this script.

if [ ! -f /usr/local/extra_homestead_software_installed ]; then
	echo 'installing some extra software'

    sudo apt install -y python2 php8.0-redis php8.0-decimal
    sudo phpenmod decimal

    sudo update-alternatives --set php /usr/bin/php8.0
    sudo update-alternatives --set php-config /usr/bin/php-config8.0
    sudo update-alternatives --set phpize /usr/bin/phpize8.0

    sudo mv /usr/lib/php/8.1 /usr/lib/php/8.1-bak

    sudo systemctl disable php8.2-fpm
    sudo systemctl enable php8.0-fpm
    sudo service php8.0-fpm restart

    #reduce openssl SECLEVEL to allow curl use md CA
    sudo sed -i '0,/^/s//openssl_conf = default_conf\n/' /usr/lib/ssl/openssl.cnf
    sudo sh -c 'cat <<EOT >> /usr/lib/ssl/openssl.cnf
[ default_conf ]
ssl_conf = ssl_sect

[ssl_sect]
system_default = system_default_sect

[system_default_sect]
MinProtocol = TLSv1.2
CipherString = DEFAULT:@SECLEVEL=0
EOT'

    sudo touch /usr/local/extra_homestead_software_installed

else
    echo "extra software already installed... moving on..."
fi
