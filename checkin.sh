#!/bin/bash

domains=("www.url1.xxx" "www.url2.xxx")

# Username and password
username=("user1@xxx.com" "user2@xxx.com")
passwd=("password1" "password2")

function auto_checkin(){
    curl -k -s -L -e  '; auto' -d "email=$2&passwd=$3&code=" -c /tmp/checkin.cook "https://$1/auth/login" > /dev/null
    retstr=$(curl -k -s -d "" -b /tmp/checkin.cook "https://$1/user/checkin")
    [ -z "${retstr}" ] && return 1
    echo ${retstr}
    # echo $(echo "${retstr}" | awk -F '"' '{print $4}')
}

for i in $( seq 0 $(( ${#username[@]}-1 )) ); do
    for d in ${domains[@]}; do
        echo "Checking in for ${username[i]} with domain $d"
        rm -rf /tmp/checkin.cook
        if ( auto_checkin $d ${username[i]} ${passwd[i]} ); then
            break
        else
            echo 'Checkin Failed!'
        fi
    done
done

