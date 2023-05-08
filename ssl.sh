#!/bin/bash

read -p "Enter domain name: " domain

apt install curl socat -y

curl https://get.acme.sh | sh

~/.acme.sh/acme.sh --set-default-ca --server letsencrypt

~/.acme.sh/acme.sh --register-account -m omid7975790@gmail.com

~/.acme.sh/acme.sh --issue -d $domain --standalone

~/.acme.sh/acme.sh --installcert -d $domain --key-file /root/p.key --fullchain-file /root/c.crt
