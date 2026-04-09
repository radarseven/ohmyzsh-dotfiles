#!/bin/bash

while [ 1 ];
do
    count=`curl -s "https://cottonbureau.com/" | grep -c "Onward"`

    if [ "$count" != "0" ]
    then
       terminal-notifier -message "Yep" -title "Onward & Downward"
       exit 0
    else
       terminal-notifier -message "Nope" -title "Onward & Downward"
    fi

    sleep 60
done