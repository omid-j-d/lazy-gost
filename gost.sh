#!/bin/bash

read -p "Select 'iran' or 'outside': " choice

read -p "Enter the port number: " port

read -p "Enter the service number: " number

if [[ "$choice" == "iran" ]]; then

  read -p "Enter the domain name: " domain

  execstart="-L=tcp://:$port -F forward+tls://$domain:2056?secure=true&serverName=$domain"

else

  execstart="-L=tls://:2056/:$port?cert=/root/c.crt&key=/root/p.key"

fi

echo "[Unit]

Description=GO Simple Tunnel

After=network.target

Wants=network.target

[Service]

Type=simple

ExecStart=/root/gost $execstart

[Install]

WantedBy=multi-user.target" > /etc/systemd/system/gost$number.service

systemctl daemon-reload

systemctl enable gost$number

systemctl restart gost$number

systemctl start gost$number

systemctl status gost&number
