wget https://github.com/go-gost/gost/releases/download/v3.0.0-rc7/gost_3.0.0-rc7_linux_amd64.tar.gz
tar -xvzf gost_3.0.0-rc7_linux_amd64.tar.gz
rm -r gost_3.0.0-rc7_linux_amd64.tar.gz

#!/bin/bash

read -p "Select 'i' for internal and 'o' for outside server : " choice
read -p "Enter the port number: " port
read -p "Enter the tunneling port number: " tport
read -p "Enter the service number: " number

if [[ "$choice" == "i" ]]; then
  read -p "Enter the domain name: " domain
  execstart="-L=tcp://:$port -F forward+tls://$domain:$tport?secure=true&serverName=$domain"
else
  execstart="-L=tls://:$tport/:$port?cert=/root/c.crt&key=/root/p.key"
fi
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
