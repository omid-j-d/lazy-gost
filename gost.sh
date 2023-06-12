#!/bin/bash

if [ ! -f gost ]; then
  wget https://github.com/go-gost/gost/releases/download/v3.0.0-rc8/gost_3.0.0-rc8_linux_amd64.tar.gz
  tar -xvzf gost_3.0.0-rc8_linux_amd64.tar.gz
  rm gost_3.0.0-rc8_linux_amd64.tar.gz
fi

valid_choice=false

while [ "$valid_choice" = false ]; do
  read -p "Select 'i' for internal and 'o' for outside server: " choice

  if [ "$choice" = "i" ]; then
    valid_choice=true
    read -p "Enter 't' for forward+tls, 'g' for forward+grpc, or any other key for default (forward+tls): " forward_choice

    read -p "Enter the domain name: " domain
    read -p "Enter the port number: " port
    read -p "Enter the tunneling port number: " tport

    if [ "$forward_choice" = "t" ]; then
      execstart="-L=tcp://:$port -F forward+tls://$domain:$tport?secure=true&serverName=$domain"
    elif [ "$forward_choice" = "g" ]; then
      execstart="-L=tcp://:$port -F forward+grpc://$domain:$tport"
    else
      execstart="-L=tcp://:$port -F forward+tls://$domain:$tport?secure=true&serverName=$domain"
    fi

  elif [ "$choice" = "o" ]; then
    valid_choice=true
    read -p "Enter 'g' for forward+grpc or any other key for default (forward+tls): " forward_choice

    read -p "Enter the port number: " port
    read -p "Enter the tunneling port number: " tport

    if [ "$forward_choice" = "g" ]; then
      execstart="-L=grpc://:$tport/:$port"
    else
      execstart="-L=tls://:$tport/:$port?cert=/root/c.crt&key=/root/p.key"
    fi

  else
    echo "Invalid choice. Please select 'i' or 'o'."
    continue
  fi

  read -p "Enter the service number: " number

  echo "[Unit]
Description=GO Simple Tunnel
After=network.target
Wants=network.target

[Service]
Type=simple
ExecStart=/root/gost $execstart
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/gost$number.service

  ufw allow $tport
  ufw allow $port

  systemctl daemon-reload
  systemctl enable gost$number
  systemctl restart gost$number
  systemctl start gost$number
  systemctl status gost$number
done
