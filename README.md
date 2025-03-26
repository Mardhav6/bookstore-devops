# PHP Bookstore Application with DevOps Setup

This is a PHP-based bookstore application with a complete DevOps pipeline setup including Docker, Kubernetes, Jenkins, Terraform, and monitoring tools.

## Technologies Used

- PHP 8.1
- MySQL
- Docker & Docker Compose
- Kubernetes
- Jenkins
- Terraform
- AWS (EKS)
- Prometheus & Grafana
- SonarQube
- Trivy

## Project Structure

```
.
├── Dockerfile              # Docker configuration
├── docker-compose.yml      # Local development setup
├── k8s/                    # Kubernetes manifests
├── terraform/              # AWS infrastructure code
├── src/                    # PHP application source code
└── monitoring/             # Prometheus and Grafana configs
```

## Local Development Setup

1. Clone the repository:
```bash
git clone <repository-url>
cd bookstore
```

2. Start the local development environment:
```bash
docker-compose up -d
```

3. Access the application:
- Web application: http://localhost:8080
- PHPMyAdmin: http://localhost:8081

## Deployment

### Prerequisites

- AWS CLI configured
- kubectl installed
- Terraform installed
- Docker installed

### Steps

1. Build and push Docker image:
```bash
docker build -t bookstore-app .
docker push <your-registry>/bookstore-app
```

2. Deploy infrastructure:
```bash
cd terraform
terraform init
terraform apply
```

3. Deploy application to Kubernetes:
```bash
kubectl apply -f k8s/
```

## Monitoring

- Prometheus: http://prometheus:9090
- Grafana: http://grafana:3000

## CI/CD Pipeline

The Jenkins pipeline includes:
1. Code quality analysis with SonarQube
2. Security scanning with Trivy
3. Docker image building and pushing
4. Kubernetes deployment
5. Monitoring setup

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details. 