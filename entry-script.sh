
#!/bin/bash
sudo yum update -y
sudo yum install -y docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user
docker run -dp 8080:80 nginx
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo echo "Hello World from $(hostname -f)" > /var/www/html/index.html
sudo yum install -y git