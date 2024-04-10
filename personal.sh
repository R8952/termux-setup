#!/bin/bash

export PRD=$(pwd)

source $PRD/support/colors.sh
source $PRD/support/functions.sh

banner "Updating App"
apt update -y && apt upgrade -y
success "Updation Complete"

askYN "Install Extra Packages?"
if [[ "$rsp" = "Y" || "$rsp" = "y" ]]; then
    pkg=( "exiftool" "gtypist" "gh" )
    ins "${pkg[@]}"
fi

askYN "Setup Laravel?"
if [[ "$rsp" = "Y" || "$rsp" =  "y" ]]; then
    composer global require laravel/installer
    echo "export PATH=\"$PATH:$HOME/.composer/vendor/bin\"" >> $HOME/.bash_config/environment_variables.sh
fi

askYN "Setup Redis & igbinary in php.ini?"
if [[ "$rsp" = "Y" || "$rsp" = "y" ]]; then

    apt install redis autoconf

    git clone https://github.com/igbinary/igbinary
    cd igbinary
    phpize
    ./configure
    ./configure CFLAGS="-O2 -g" --enable-igbinary
    make
    make test
    make install

    echo ""
    echo "; Load igbinary extension" >> $PREFIX/lib/php.ini
    echo "extension=igbinary.so" >> $PREFIX/lib/php.ini
    echo "" >> $PREFIX/lib/php.ini
    echo "; Use igbinary as session serializer" >> $PREFIX/lib/php.ini
    echo "session.serialize_handler=igbinary" >> $PREFIX/lib/php.ini
    echo "" >> $PREFIX/lib/php.ini
    echo ; Enable or disable compacting of duplicate strings" >> $PREFIX/lib/php.ini
    echo "; The default is On." >> $PREFIX/lib/php.ini
    echo "igbinary.compact_strings=On" >> $PREFIX/lib/php.ini
    echo "" >> $PREFIX/lib/php.ini
    echo "; If uncommented, use igbinary as the serializer of APCu" >> $PREFIX/lib/php.ini
    echo "; (APCu 5.1.10 or newer is strongly recommended)" >> $PREFIX/lib/php.ini
    echo "; apc.serializer=igbinary" >> $PREFIX/lib/php.ini
    echo ""

    cd ..

    git clone https://github.com/phpredis/phpredis.git
    cd phpredis
    phpize
    # Redis with igbinary is currently not working
    ./configure #--enable-redis-igbinary
    make && make install

    echo ""
    echo "extension=redis.so" >> $PREFIX/lib/php.ini
    echo ""

    echo "redis=\"mkcd $HOME/temp/redis_dump && redis-server --ignore-warnings ARM64-COW-BUG\"" >> $HOME/.bash_config/aliases.sh

    cd ..

   rm -rf phpredis igbinary
fi

askYN "Setup MariaDB?"
if [[ "$rsp" = "Y"  ||  "$rsp" = "y" ]]; then
    apt install mariadb -y
    echo -e "${CYAN}Enter ${YELLOW}mariadbd ${CYAN}to start the server."
    echo -e "And"
    echo -e "To enter the mariadb shell enter mariadb -u <username> -p"
    askYN "Create new User?"
    if [[ "$rsp" = "Y" || "$rsp" = "y" ]]; then
        read -p "Enter Username : " uname
        read -p "Enter Password : " password
        mariadb -u root -e "CREATE USER '$uname'@'localhost' IDENTIFIED BY '$password';"
        mariadb -u root -e "GRANT ALL PRIVILEGES ON *.* TO '$uname'@'localhost' WITH GRANT OPTION;"
        mariadb -u root -e "FLUSH PRIVILEGES;"
    fi
fi

askYN "Install VScode?"
if [[ "$rsp" = "Y" || "$rsp" = "y" ]]; then
    apt install code-oss;
fi
