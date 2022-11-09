#!/bin/bash

# run 'crontab -e' and add the following:
# 0,5,10,15,20,25,30,35,40,45,50,55 * * * * /home/scanps.sh > /dev/null 2>&1

cd /home
php scanps.php
