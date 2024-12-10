### php ###
php_ext_dir="/usr/lib/php/20220829"

# if [ "$debian_release" != "bookworm" ] || [ $php_ver != "8.2" ]; then
    ${SUDO} wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
    printf "deb https://packages.sury.org/php/ ${debian_release} main\n" | ${SUDO} tee /etc/apt/sources.list.d/php.list
# fi

# 'Drupal/CiviCRM requirements'
# 'php-fpm php-apcu php-bcmath php-Curl php-gd php-Intl php-mbstring php-mysql php-soap php-xml php-Zip php-zstd'

${SUDO} apt update
${SUDO} apt full-upgrade
${SUDO} apt install php${php_ver}-fpm php${php_ver}-apcu php${php_ver}-bcmath php${php_ver}-curl php${php_ver}-gd php${php_ver}-intl php${php_ver}-mbstring php${php_ver}-mysql php${php_ver}-soap php${php_ver}-xml php${php_ver}-zip php${php_ver}-redis
${SUDO} apt install php${php_ver}-zstd

# Install uploadprogress extension
if [ "$php_ver" = "8.2" ]; then
	if [ -d "$php_ext_dir" ]; then
        ${SUDO} cp $setup_dir/misc/uploadprogress.so $php_ext_dir
        ${SUDO} cp $setup_dir/misc/uploadprogress.ini /etc/php/8.2/mods-available/
        ${SUDO} ln -s /etc/php/8.2/mods-available/uploadprogress.ini /etc/php/8.2/fpm/conf.d/30-uploadprogress.ini
    else
        printf "${php_ext_dir} does not exist\n"
    fi
else
    printf "uploadprogress extension not installed for php version ${php_ver}"
fi

${SUDO} cp -rbv $setup_dir/etc/php/${php_ver}/* /etc/php/${php_ver}


$HOME/.local/bin/get-utils composer
