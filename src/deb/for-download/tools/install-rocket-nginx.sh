#!/bin/bash

echo "Updating apt, please wait..."
apt-get update > /dev/null 2>&1

apt-get -y install git > /dev/null 2>&1

if [ ! -d "/etc/nginx/rocket-nginx" ]; then
    cd /etc/nginx
    git clone https://github.com/satellitewp/rocket-nginx.git
else
    cd /etc/nginx/rocket-nginx
    git pull
    cd ..
fi

cd rocket-nginx
cp rocket-nginx.ini.disabled rocket-nginx.ini
php rocket-parser.php
wget -nv -O /usr/local/vesta/data/templates/web/nginx/wprocket-force-htpps.tpl https://c.myvestacp.com/tools/rocket-nginx-templates/wprocket-force-htpps.tpl
wget -nv -O /usr/local/vesta/data/templates/web/nginx/wprocket-force-htpps.stpl https://c.myvestacp.com/tools/rocket-nginx-templates/wprocket-force-htpps.stpl
wget -nv -O /usr/local/vesta/data/templates/web/nginx/wprocket-hosting.tpl https://c.myvestacp.com/tools/rocket-nginx-templates/wprocket-hosting.tpl
wget -nv -O /usr/local/vesta/data/templates/web/nginx/wprocket-hosting.stpl https://c.myvestacp.com/tools/rocket-nginx-templates/wprocket-hosting.stpl
