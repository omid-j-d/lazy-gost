#!/bin/bash

read -p "Enter domain name: " domain
read -p "Enter your email: " email

curl https://get.acme.sh | sh

~/.acme.sh/acme.sh --set-default-ca --server letsencrypt

~/.acme.sh/acme.sh --register-account -m $email

~/.acme.sh/acme.sh --issue -d $domain --standalone

~/.acme.sh/acme.sh --installcert -d $domain --key-file /root/p.key --fullchain-file /root/c.crt
