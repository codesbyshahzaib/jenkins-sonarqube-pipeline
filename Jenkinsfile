pipeline {
    agent any

    tools {
        nodejs 'node'
    }

    environment {
        IMAGE_NAME = 'devops-backend-api'
        SCANNER_HOME = tool 'sonar-scanner'
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
                echo "Code checked out successfully!"
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    dir('devops-backend-api') {
                        sh "${SCANNER_HOME}/bin/sonar-scanner -Dsonar.projectKey=${IMAGE_NAME} -Dsonar.projectName=${IMAGE_NAME} -Dsonar.sources=."
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('devops-backend-api') {
                    echo "Building Docker Image..."
                    sh "docker build -t ${IMAGE_NAME}:latest ."
                }
            }
        }
    }
}
