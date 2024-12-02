pipeline {
    agent any
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/holadmex/3-Tier-web-architecture.git'
            }
        }

        stage('Build Frontend Docker Image') {
            steps {
                script {
                    sh """
                    docker build -t $FRONTEND_IMAGE -f frontend/Dockerfile frontend/
                    """
                }
            }
        }
    }
}
