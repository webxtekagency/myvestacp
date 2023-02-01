#!/bin/bash
# info: Install rocket-nginx extension for certain domain
# options: DOMAIN 

#----------------------------------------------------------#
#                    Variable&Function                     #
#----------------------------------------------------------#

whoami=$(whoami)
if [ "$whoami" != "root" ]; then
    echo "You must be root to execute this script"
    exit 1
fi

# Importing system environment
source /etc/profile

# Argument definition
domain=$1

user=$(/usr/local/vesta/bin/v-search-domain-owner $domain)
USER=$user

# Includes
source /usr/local/vesta/func/main.sh
source /usr/local/vesta/func/domain.sh

if [ -z "$user" ]; then
    check_result $E_NOTEXIST "domain $domain doesn't exist"
fi


#----------------------------------------------------------#
#                    Verifications                         #
#----------------------------------------------------------#

check_args '1' "$#" 'DOMAIN'
is_format_valid 'domain'
is_object_valid 'user' 'USER' "$user"
is_object_unsuspended 'user' 'USER' "$user"

if [ ! -d "/home/$user" ]; then
    echo "User doesn't exist";
    exit 1;
fi

if [ ! -d "/home/$user/web/$domain/public_html" ]; then
    echo "Domain doesn't exist";
    exit 1;
fi

if [ ! -d "/etc/nginx/rocket-nginx" ]; then
    echo "rocket-nginx is not installed";
    echo "Do you want to install it now (y/n)?"
    read answer
    if [ "$answer" == "y" ]; then
        echo "Installing rocket-nginx..."
        curl -sL https://c.myvestacp.com/tools/install-rocket-nginx.sh | bash -
    else
        echo "Exiting script"
        exit 1;
    fi
fi


#----------------------------------------------------------#
#                       Action                             #
#----------------------------------------------------------#

# Chaning Proxy Template
echo "Do you want to force-https in your Proxy Template or not (y/n):"
read answer
if [ "$answer" == "y" ]; then
    /usr/local/vesta/bin/v-change-web-domain-proxy-tpl "$user" "$domain" "wprocket-force-https"
else
    /usr/local/vesta/bin/v-change-web-domain-proxy-tpl "$user" "$domain" "wprocket-hosting"
fi
echo "Proxy Template is ready"

# Checking if the website is WordPress
if [ ! -f "/home/$user/web/$domain/public_html/wp-config.php" ]; then
    echo 'Please install WordPress first.'
    exit 1;
fi

# Disabling wp-cron in wp-config.php
echo "Disabling WP-Cron in your wp-config.php..."
string="define( 'DISABLE_WP_CRON', true );"
line="define( 'DB_COLLATE', '' );"
file="/home/$user/web/$domain/public_html/wp-config.php"
sed -i "/$line/a $string" $file

# Adding cron job
echo "Adding cron job..."

TPL=$(/usr/local/vesta/bin/v-list-web-domain $user $domain shell | grep 'TEMPLATE:' | awk '{print $2}')
if [[ $TPL == "PHP-FPM-"* ]]; then
    fpm_tpl_ver=${TPL:8:2}
    fpm_ver="${TPL:8:1}.${TPL:9:1}"
fi

touch /home/$user/web/$domain/cron.log
chown $user:$user /home/$user/web/$domain/cron.log

case $fpm_ver in
    5.6 | 7.0 | 7.1 | 7.2 | 7.3 | 7.4 | 8.0 | 8.1 | 8.2) 
    /usr/local/vesta/bin/v-add-cron-job "$user" "*/15" "*" "*" "*" "*" "cd /home/$user/web/$domain/public_html; /usr/bin/php$fpm_ver wp-cron.php >/home/$user/web/$domain/cron.log 2>&1"
    ;;
esac

#----------------------------------------------------------#
#                       Vesta                              #
#----------------------------------------------------------#
echo "Installation is completed."

exit
