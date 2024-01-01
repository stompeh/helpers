#!/usr/bin/env bash

echo "Stopping Apache2 service"
systemctl stop apache2

echo "Updating apt packages"
sudo apt update && sudo apt upgrade -y

echo "Installing security2 apache mod library"
sudo apt install libapache2-mod-security2 -y

echo "Unsetting /etc/apache2/sites-available/000-default.conf as the current site config"
sudo a2dissite 000-default.conf

echo "Enabling proxy/reverse mods"
sudo a2enmod rewrite deflate headers proxy proxy_ajp proxy_http proxy_balancer proxy_connect proxy_html

echo "Disabling indexing"
sudo a2dismod autoindex -f

echo "Enabling security2"
sudo a2enmod security2

echo "From here you can turn on and set server signatures. Ex:"
echo "sudo sed -i \"s/ServerSignature On/ServerSignature Off/g\" /etc/apache2/conf-available/security.conf"
echo "echo \"SecServerSignature Microsoft-IIS/10.0\" | sudo tee -a /etc/apache2/conf-available/security.conf"
echo "sudo sed -i \"s/ServerTokens OS/ServerTokens Full/g\" /etc/apache2/conf-available/security.conf"

echo "Creating new site my-new-domain-http.conf from default template"
cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/my-new-domain-http.conf

echo "Enabling new site my-new-domain-http.conf"
sudo a2ensite my-new-domain-http.conf

echo "Starting apache2 service"
sudo systemctl start apache2

echo "Exiting"
exit 0
