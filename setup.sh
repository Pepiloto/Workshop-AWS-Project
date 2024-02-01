#!/bin/bash -xe

SAMPLE_APP_S3_URL="s3://lab0-bucket/SampleApp"
UWSGI_CONFIG_S3_URL="s3://lab0-bucket/sample-app.uwsgi.service"
NGINX_CONFIG_S3_URL="s3://lab0-bucket/nginx-app.conf"

# Install OS packages
sudo yum update -y
sudo yum groupinstall -y "Development Tools"
sudo amazon-linux-extras install -y nginx1
sudo yum install -y nginx python3 python3-pip python3-devel
sudo pip3 install pipenv wheel
sudo pip3 install uwsgi

sudo mkdir -p /var/www/
sudo aws s3 cp $SAMPLE_APP_S3_URL /var/www/SampleApp --recursive
cd /var/www/SampleApp
sudo usermod -a -G nginx ec2-user
sudo chown ec2-user:nginx -R ./*
sudo chown ec2-user:nginx /var/www
sudo chown ec2-user:nginx /var/www/SampleApp

sudo aws s3 cp $UWSGI_CONFIG_S3_URL /etc/systemd/system/mywebapp.uwsgi.service
sudo mkdir -p /var/log/uwsgi
sudo chown ec2-user:nginx /var/log/uwsgi
sudo systemctl enable mywebapp.uwsgi.service
sudo systemctl start mywebapp.uwsgi.service

sudo aws s3 cp $NGINX_CONFIG_S3_URL /etc/nginx/conf.d/nginx-app.conf
sudo systemctl enable nginx.service
sudo systemctl stop nginx.service
sudo systemctl restart nginx.service

echo "Custom configuration for sample application complete."