pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'bookstore-app'
        DOCKER_TAG = "${BUILD_NUMBER}"
        SONAR_TOKEN = credentials('sonar-token')
        AWS_CREDENTIALS = credentials('aws-credentials')
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh """
                        sonar-scanner \
                        -Dsonar.projectKey=bookstore \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=http://localhost:9000 \
                        -Dsonar.login=${SONAR_TOKEN}
                    """
                }
            }
        }
        
        stage('Security Scan') {
            steps {
                sh """
                    trivy image ${DOCKER_IMAGE}:${DOCKER_TAG} --severity HIGH,CRITICAL
                """
            }
        }
        
        stage('Build Docker Image') {
            steps {
                sh """
                    docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                    docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest
                """
            }
        }
        
        stage('Push to ECR') {
            steps {
                withAWS(credentials: 'aws-credentials', region: 'us-east-1') {
                    sh """
                        aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com
                        docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${DOCKER_IMAGE}:${DOCKER_TAG}
                        docker push ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${DOCKER_IMAGE}:${DOCKER_TAG}
                    """
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                sh """
                    kubectl set image deployment/bookstore-app bookstore-app=${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${DOCKER_IMAGE}:${DOCKER_TAG}
                """
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
} 