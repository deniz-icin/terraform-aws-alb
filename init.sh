#!/bin/bash

yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Basic Web App from $(hostname -f)</h1>"> /var/www/html/index.html
