#!/bin/bash

# Update system
sudo dnf update -y

# Install Docker
sudo dnf install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install Jenkins
sudo dnf install -y java-17-amazon-corretto
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo dnf install -y jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Install SonarQube
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.1.69595.zip
sudo dnf install -y unzip
sudo unzip sonarqube-9.9.1.69595.zip -d /opt
sudo mv /opt/sonarqube-9.9.1.69595 /opt/sonarqube
sudo chown -R jenkins:jenkins /opt/sonarqube

# Install Trivy
sudo curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b /usr/local/bin v0.18.3

# Install kubectl
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Install AWS CLI
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo dnf install -y unzip
sudo unzip awscliv2.zip
sudo ./aws/install

# Install Terraform
sudo dnf install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo dnf install -y terraform

# Add jenkins user to docker group
sudo usermod -aG docker jenkins

# Print Jenkins initial admin password
echo "Jenkins initial admin password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# Print SonarQube status
echo "Starting SonarQube..."
sudo -u jenkins /opt/sonarqube/bin/linux-x86-64/sonar.sh start

echo "Setup completed! Please log out and log back in for group changes to take effect." 