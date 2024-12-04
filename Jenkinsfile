pipeline {
    agent any

    environment {
        FRONTEND_IMAGE = "your-frontend-image:latest"
        DOCKER_IMAGE = "your-image:latest"
        AWS_ACCESS_KEY_ID = credentials('aws-key') // Jenkins credential ID for access key
        AWS_SECRET_ACCESS_KEY = credentials('aws-key') // Jenkins credential ID for secret key
        ECR_REPO = "429841094792.dkr.ecr.us-east-1.amazonaws.com/frontend"
        ECS_TASK_DEFINITION = task-web-app
        ECS_CLUSTER =  full-stack-web-app
        $ECS_SERVICE = web-app-service
        AWS_REGION = "us-east-1"
        SONAR_PROJECT_KEY = "3-Tier-web-architecture"
        SONAR_ORG = "ecs-ci-cd"
        SONAR_TOKEN = credentials('sonar-login') // Add token in Jenkins credentials
        SONAR_SCANNER_PATH = '/opt/sonar-scanner/bin'
        PATH = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/snap/bin:${SONAR_SCANNER_PATH}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

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
        stage('Set Up SonarScanner') {
            steps {
                script {
                    sh '''
                    export PATH=$PATH:/opt/sonar-scanner/bin
                    echo $PATH
                    which sonar-scanner
                    '''
                }
            }
        }
        stage('SonarCloud Analysis') {
            steps {
                withSonarQubeEnv('SonarCloud') {
                    sh '''
                    sonar-scanner \
                    -Dsonar.projectKey=3-Tier-web-architecture \
                    -Dsonar.organization=ecs-ci-cd \
                    -Dsonar.login=$SONAR_TOKEN \
                    -Dsonar.host.url=https://sonarcloud.io \
                    -Dsonar.sourceEncoding=UTF-8 \
                    -Dsonar.sources=frontend \
                    -Dsonar.exclusions=**/test/**,**/*.spec.js
                    '''
                }
            }
        }
        stage('Wait for Quality Gate') {
            steps {
                script {
                    def qualityGate = waitForQualityGate()
                    if (qualityGate.status != 'OK') {
                        error "Quality gate failed: ${qualityGate.status}"
                    }
                }
            }
        }
        stage('Run Trivy Scan') {
            steps {
                script {
                    // Scan the Docker image for vulnerabilities
                    sh "trivy image --severity HIGH,CRITICAL $FRONTEND_IMAGE || exit 1"
                }
            }
        }
        stage('Push Docker Image to ECR') {
            steps {
                script {
                    // Authenticate Docker to ECR
                    sh """
                    aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO
                    docker tag $FRONTEND_IMAGE $ECR_REPO:$BUILD_NUMBER
                    docker push $ECR_REPO:$BUILD_NUMBER
                    """
                }
            }
        }
        stage('Update ECS Service') {
            steps {
                script {
                    // Update the ECS task definition and ECS service with the new image
                    sh """
                    ecs_task_definition=\$(aws ecs describe-task-definition --task-definition $ECS_TASK_DEFINITION | jq '.taskDefinition')
                    new_container_definitions=\$(echo \$ecs_task_definition | jq ".containerDefinitions | map(if .name == \\"frontend\\" then .image = \\"$ECR_REPO:$BUILD_NUMBER\\" else . end)")
                    updated_task_definition=\$(echo \$ecs_task_definition | jq ".containerDefinitions = \$new_container_definitions")
                    new_task_definition_name=\$(echo \$updated_task_definition | jq -r '.family')
                    
                    # Register the new task definition
                    task_definition_revision=\$(aws ecs register-task-definition \
                        --family \$new_task_definition_name \
                        --container-definitions "\$new_container_definitions" | jq -r '.taskDefinition.taskDefinitionArn')
                    
                    # Get the ECS service and update it with the new task definition revision
                    aws ecs update-service --cluster $ECS_CLUSTER --service $ECS_SERVICE --task-definition \$task_definition_revision
                    """
        }
    }
}
    }
    post {
        always {
            cleanWs()
        }
    }
}


