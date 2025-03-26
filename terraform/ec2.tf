# EC2 Instance
resource "aws_instance" "devops_server" {
  ami           = "ami-0c7217cdde317cfec"  # Ubuntu 22.04 LTS
  instance_type = "t2.xlarge"              # 4 vCPU, 16GB RAM
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = "bookstore-key"           # You'll need to create this key pair

  vpc_security_group_ids = [aws_security_group.devops_sg.id]

  root_block_device {
    volume_size = 100
    volume_type = "gp3"
  }

  user_data = <<-EOF
              #!/bin/bash
              # Update system
              apt-get update && apt-get upgrade -y

              # Install Docker
              apt-get install -y apt-transport-https ca-certificates curl software-properties-common
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
              add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
              apt-get update
              apt-get install -y docker-ce docker-ce-cli containerd.io

              # Install Docker Compose
              curl -L "https://github.com/docker/compose/releases/download/v2.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose

              # Install Jenkins
              wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add -
              sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
              apt-get update
              apt-get install -y jenkins

              # Install SonarQube
              wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.1.69595.zip
              apt-get install -y unzip
              unzip sonarqube-9.9.1.69595.zip -d /opt
              mv /opt/sonarqube-9.9.1.69595 /opt/sonarqube
              chown -R jenkins:jenkins /opt/sonarqube

              # Install Trivy
              curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin v0.18.3

              # Install kubectl
              curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
              chmod +x kubectl
              mv kubectl /usr/local/bin/

              # Install AWS CLI
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              ./aws/install

              # Install Terraform
              wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
              echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
              apt-get update
              apt-get install -y terraform

              # Start services
              systemctl start jenkins
              systemctl enable jenkins

              # Add jenkins user to docker group
              usermod -aG docker jenkins
              EOF

  tags = {
    Name = "devops-server"
  }
}

# Security Group for DevOps Server
resource "aws_security_group" "devops_sg" {
  name        = "devops-security-group"
  description = "Security group for DevOps server"
  vpc_id      = aws_vpc.bookstore_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-sg"
  }
} 