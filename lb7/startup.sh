#!/bin/bash

apt-get update
apt-get install -y nginx

HOSTNAME=$(hostname)

cat > /var/www/html/index.html <<HTML
<!DOCTYPE html>
<html>
<head>
  <title>GCP Regional ALB Lab</title>
</head>
<body>
  <h1>GCP Regional Application Load Balancer</h1>
  <p>Backend: $HOSTNAME</p>
  <p>Protocol: HTTP</p>
  <p>SSL termination: Load Balancer</p>
</body>
</html>
HTML

systemctl enable nginx
systemctl restart nginx
