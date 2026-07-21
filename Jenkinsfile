pipeline {
    agent any

    tools {
        // This tells Jenkins to use the NodeJS tool we configured earlier
        nodejs 'node'
    }

    environment {
        IMAGE_NAME = 'devops-backend-api'
        // This finds the SonarScanner tool we told Jenkins to download
        SCANNER_HOME = tool 'sonar-scanner'
    }

    stages {
        stage('Checkout Code') {
            steps {
                // This built-in step pulls your latest code from GitHub
                checkout scm
                echo "Code checked out successfully!"
            }
        }

        stage('SonarQube Analysis') {
            steps {
                // This uses the server connection we just linked!
                withSonarQubeEnv('sonarqube') {
                    // Navigate into the folder where our app code is
                    dir('devops-backend-api') {
                        // Run the scanner
                        sh "${SCANNER_HOME}/bin/sonar-scanner -Dsonar.projectKey=${IMAGE_NAME} -Dsonar.projectName=${IMAGE_NAME} -Dsonar.sources=."
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('devops-backend-api') {
                    echo "Building Docker Image..."
                    // Because we mounted docker.sock in docker-compose, Jenkins can do this!
                    sh "docker build -t ${IMAGE_NAME}:latest ."
                }
            }
        }
    }
}
