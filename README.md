# DevOps: Bridging the Gap Between Development and Operations

## Introduction
Welcome to this comprehensive guide on DevOps, a methodology that effectively bridges the traditional divide between Development and Operations teams. This article will explore how web applications are structured, developed, and deployed, with a special focus on the evolution from traditional deployment methods to modern DevOps practices.

## Web Development Architecture

### Frontend Development
The frontend represents the user interface that end users interact with directly. These end users include anyone visiting websites such as Facebook, Amazon, Twitter, eBay, or Jumia.

Standard frontend components typically include:
- HTML (structure)
- CSS (styling)
- JavaScript (interactivity)

These components may vary depending on the architectural framework chosen for the web application, with modern approaches often incorporating frameworks like React, Angular, or Vue.js.

### Backend Development
The backend serves as the intermediary layer of the web application that processes incoming and outgoing requests from end users. It handles various user interactions initiated from the frontend, including:
- User registration
- Authentication
- Shopping cart operations
- Search functionality
- Data processing

Consider a scenario where a new user visits Amazon.com and creates an account. The signup form displayed on the website is rendered by the frontend. Upon submission, the request travels to the backend, which processes the information and returns a "Successfully created account" message to the user.

Beyond handling requests, the backend prepares data for storage in the database, organizing information into tables with rows and columns. Database schemas define these structures, ensuring proper data organization and management.

### Database Layer
The database represents the final layer in our web application architecture. It serves as the persistent storage system that:
- Stores user data securely
- Maintains application information
- Organizes data in structured formats (tables, documents, etc.)
- Implements encryption for sensitive information like passwords
- Enables efficient data retrieval and manipulation

Modern databases can be relational (MySQL, PostgreSQL) or non-relational (MongoDB, Redis), each offering different advantages depending on application requirements.

## Traditional Deployment Before DevOps

Before DevOps and cloud solutions, software engineers faced numerous challenges when deploying web applications:

### Manual Deployment Process
1. Developers would write code locally and test on their machines
2. Code would be compiled and packaged into deployable artifacts
3. System administrators would receive these artifacts via physical media or FTP
4. Operations teams would manually configure servers and deploy applications
5. Configuration files would need to be manually updated for each environment

### Common Challenges
- **Environment Inconsistency**: The "it works on my machine" problem was prevalent, with development environments differing from production
- **Long Deployment Cycles**: Deployments could take days or weeks to complete
- **Limited Collaboration**: Developers and operations teams worked in isolation
- **Difficult Rollbacks**: Reverting problematic deployments was complex and risky
- **Poor Scalability**: Applications were often deployed on physical servers with limited scaling capabilities
- **Inadequate Monitoring**: Visibility into application performance was minimal

### Physical Infrastructure Management
- Applications were typically deployed on physical servers in company-owned data centers
- Hardware procurement could take months
- Scaling required purchasing additional physical machines
- Redundancy and high availability were expensive and complex to implement

## The DevOps Revolution

DevOps emerged as a solution to these challenges, promoting collaboration between development and operations teams through:

- **Automation**: Continuous Integration/Continuous Deployment (CI/CD) pipelines
- **Infrastructure as Code**: Managing infrastructure through version-controlled code
- **Containerization**: Packaging applications with their dependencies for consistent deployment
- **Cloud Services**: Leveraging scalable, on-demand infrastructure
- **Monitoring and Observability**: Comprehensive visibility into application performance
- **Microservices Architecture**: Breaking applications into smaller, independently deployable services

By implementing DevOps practices, organizations can achieve faster deployments, improved reliability, and more efficient use of resources, ultimately delivering better software experiences to end users.

## Conclusion

The evolution from traditional development and operations silos to integrated DevOps practices represents a significant advancement in software engineering. By understanding the core components of web development—frontend, backend, and database—along with modern deployment methodologies, teams can build and maintain more resilient, scalable, and user-friendly applications.


# Below Are The Prerequisites Installation Needed For This Project:

For this project, we'll need to install the following tools and technologies on our Linux Machine (Debian, Ubuntu or WSL):

# Installation Guide

## Python to be installed on PC, or Linux(Ubuntu)

```bash
# Update package index
sudo apt update

# Install Python and pip
sudo apt install -y python3 python3-pip python3-venv

# Verify installation
python3 --version
pip3 --version
```

## Docker

```bash
# Update package index
sudo apt update

# Install prerequisites
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add Docker repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Install Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Add current user to docker group (optional)
sudo usermod -aG docker $USER
```

## AWS CLI

```bash
# Install dependencies
sudo apt update
sudo apt install -y unzip

# Download and install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

AWS CLI Configuration
# On Local Laptop/PC
aws configure
AWS Access Key ID: [YOUR_ACCESS_KEY]
AWS Secret Access Key: [YOUR_SECRET_KEY]
Default region name: [e.g., us-east-1]
Default output format: json
```

## Tools & Cloud Provider Services Covered in These Project are as follows:

- Python
- Nginx
- Docker
- AWS Services:
  - IAM, EC2, S3, ECR, ECS, EKS
  - RDS, VPC, CloudWatch
  - ACM, Route 53, Load Balancer
- Jenkins
- GitHub Actions
- SonarQube
- Trivy
- Snyk
- Ansible
- Terraform
- Kubernetes

## Project Implementation Guide Running the Full Stack Application Locally

To get your application up and running locally, you'll need to run three components simultaneously: the PostgreSQL database, the backend server, and the frontend application. Here's how to manage all these components and verify the full workflow:

### Step 1: Accessing the Codebase

We'll need to clone the repository to our local machine after receiving access to the project URL from the Development team.


### Step 2: Setting Up the Development Database

To properly test backend functionality, set up a local PostgreSQL database:

#### PostgreSQL Installation and Configuration

```bash
# Update package lists
sudo apt update

# Install PostgreSQL and additional utilities
sudo apt install postgresql postgresql-contrib

# Verify installation
psql --version

# Check service status
sudo systemctl status postgresql

# Log in as the default PostgreSQL user
sudo -u postgres psql
```

#### Database Creation and User Setup

Once logged in as the postgres user, create your database, user, and set appropriate permissions:

```sql
-- Create application database
CREATE DATABASE ecommerce_db;

-- Create application user with password
CREATE USER ecommerce WITH PASSWORD 'testing123';

-- Configure user settings
ALTER ROLE ecommerce SET client_encoding TO 'utf8';
ALTER ROLE ecommerce SET timezone TO 'UTC';

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE ecommerce_db TO ecommerce;
```

#### Extended Privileges for Development

For the development environment, you will need to grant additional privileges:

```sql
-- Grant superuser privileges (use with caution in production)
ALTER USER ecommerce WITH SUPERUSER;

-- Grant schema-level permissions
GRANT USAGE ON SCHEMA public TO ecommerce;
GRANT CREATE ON SCHEMA public TO ecommerce;

-- Grant table and sequence permissions
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ecommerce;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO ecommerce;

-- Exit PostgreSQL command prompt
\q
```

## PostgreSQL Configuration File Modifications Before Connecting to Your Newly Created Database

For proper database connectivity, especially in development environments, you'll need to edit two key configuration files:

1. Client Authentication Configuration:
   ```bash
   sudo nano /etc/postgresql/16/main/pg_hba.conf
   ```
   Modify this file to change all `peer` connection settings, to `md5` allowing your created user to access the database with the registered password.

![alt text](<Screenshot 2025-04-10 200527-1.png>)

2. PostgreSQL Server Configuration:
   ```bash
   sudo nano /etc/postgresql/16/main/postgresql.conf
   ```
   Uncomment and modify the `listen_addresses` parameter to allow connections from specific IP addresses or from anywhere, depending on your security requirements.

Remember to restart PostgreSQL after making configuration changes:
```bash
sudo systemctl restart postgresql
```

#### Connecting to Your Database

```bash
# Connect to local database
psql -U ecommerce -d ecommerce_db
```
![alt text](<Screenshot 2025-04-10 200317.png>)

#### Useful PostgreSQL Commands

```sql
\du   -- List all database users and their roles
\d    -- List all relations
\l    -- List all databases
```

### Important Production Considerations

For production environments, carefully evaluate the permissions granted to database users. While superuser privileges simplify development, they should be limited in production to follow the principle of least privilege. Consider creating specific roles with only the necessary permissions for your application's functionality.

Additionally, ensure proper network security configurations when exposing database connections beyond localhost, particularly when using cloud-based database services like AWS RDS.

### Step 3: Exploring the Frontend

To understand the user interface that end users will interact with:

1. Navigate to the frontend code directory
2. Start a local server to view the application:
   ```bash
   python3 -m http.server 8000
   ```
   Note: You can change port 8000 to any available port of your choice.

## Access the Frontend in Your Browser

Open your web browser and navigate to the frontend application:

If using Python's http.server: `http://localhost:8000`

![alt text](<Screenshot 2025-02-21 201045.png>)

### Step 4: Backend Setup and Configuration

After setting up the database, the next step is to configure and run the backend code. Using a Python virtual environment is recommended to isolate dependencies and avoid conflicts.

## NB: Open a new terminal window (keep the frontend terminal running) and navigate to your backend directory

## Python Virtual Environment Setup

```bash
# Create a virtual environment
python3 -m venv venv

# Activate the virtual environment
source venv/bin/activate
```

## Backend Dependencies Installation

```bash
# Update pip
python -m pip install --upgrade pip

# Install required packages individually
pip install flask Flask-Cors Flask-SQLAlchemy Flask-Migrate bcrypt python-dotenv psycopg2-binary

# Alternative: Install from requirements.txt
pip install -r requirements.txt
```

## Start the backend server:

`python app.py`

You should see output indicating that your Flask application is running, typically on port 5000.

## Sign Up a New User

Navigate to the frontend web page on your browser, on the signup page on your web application, and create a user account. If everything is configured correctly, you should see a success message or be redirected to a login page.

## Next Step: Verify Data in PostgreSQL; Database Verification Commands

Connect to your database and verify the data:
```bash
# Connect to the database
psql -U ecommerce -d ecommerce_db

# Show all users and privileges
\du

# List all relations (tables)
\d

# List all databases
\l

# Switch to PostgreSQL default database
\c postgres

# Describe a specific table
\d user

# Data Query in our PostgreSQL Database
SELECT * FROM "user";
SELECT * FROM "user" WHERE email = 'test@example.com';
```
`SELECT * FROM "user";`

![alt text](<Screenshot 2025-04-10 201458.png>)

## Docker Containerization of both Frontend and Backend

```bash
cd frontend

# Build the frontend Docker image
docker build -t frontend .

# Run the frontend container
docker run -d --name web -p 80:80 frontend

# Check built images
docker images

# Check running containers
docker ps 

# Check all running containers
docker ps -a
```

```bash
cd backend

# Build the backend Docker image
docker build -t backend .

# Run the backend container
docker run -d --name web -p 5000:5000 backend

# Check built images
docker images

# Check running containers
docker ps 

# Check all running containers
docker ps -a
```

## Integration of Docker Compose for our Full-Stack Application Deployment
Docker Compose provides a convenient way to orchestrate multiple containers that make up your application stack. For our e-commerce application, we'll use Docker Compose to configure and link these three essential components: the PostgreSQL database, the backend Flask API, and the frontend web interface.


### Environment Configuration Changes
Backend `.env` File Modifications
The key modification for Docker networking is changing the database host from localhost or 127.0.0.1 to the service name db as defined in the docker-compose.yml file:

```bash
- DATABASE_URI=postgresql://ecommerce:password@127.0.0.1:5432/ecommerce_db
+ DATABASE_URI=postgresql://ecommerce:password@db:5432/ecommerce_db
```

In the Docker Compose setup, we're passing this as an environment variable directly to the container, eliminating the need for a .env file in the Docker image.

### Running the Dockerize Application

```bash
NB: Make sure you are at the project root directory to execute theses command.

To start the entire stack with Docker Compose:

<docker-compose up -d>
OR
<docker compose build>

To stop the entire stack with Docker Compose:

<docker compose down>

After starting the stack with <docker-compose up -d>, navigate to http://localhost in your browser to access you frontend home page as we did earlier at the beginning of the local test setup.
```



## Database Migration Management 

This is most likely (optional) while having some error's in trying to create a user account on the web page, right after spinning up the full stack container's with `docker compose up` 

## Flask-Migrate helps manage database schema changes:

```bash
# Install Flask-Migrate
pip install flask-migrate flask-sqlalchemy

# Initialize migration repository
flask db init

# Create initial migration
flask db migrate

# Apply migrations to the database
flask db upgrade

# Check current migration version
flask db current

# If needed, reset migrations
rm -rf migrations/
flask db init
flask db migrate -m "Recreate migrations"
flask db upgrade
```

# DevOps Infrastructure and CI/CD Setup Guide

## Prerequisites
- AWS Account
- Terraform
- Dockers
- AWS CLI
- SonarCloud
- Trivy
- Jenkins

## 1. Terraform Infrastructure Provisioning

### 1.1 Local Terraform Setup
```bash
# Install Terraform on Ubuntu
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

# Navigate to terraform directory
cd ./ecs-terraform
```

### Run the following Terraform Commands
```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Plan infrastructure
terraform plan

# Apply infrastructure
terraform apply
```

# EC2 Setup and Configuration Guide

## 1. EC2 Instance Provisioning

### Instance Recommendations
- Type: t3.medium (recommended for Jenkins)
- OS: Ubuntu 22.04 LTS
- Storage: Minimum 20GB
- Security Group:
  - Inbound Rules:
    - SSH (Port 22): Your IP
    - HTTP (Port 80)
    - Jenkins (Port 8080)

## Initial EC2 Setup, SSH Into The Server With The Public IP Address

### System Update
```bash
ssh -i downnloads/key.pem ubuntu@<public-ip>
sudo apt update && sudo apt upgrade -y
```

## Docker Installation

```bash
# Update package index
sudo apt update

# Install prerequisites
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add Docker repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Install Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Add current user to docker group (optional)
sudo usermod -aG docker $USER
```

## AWS CLI Installation

```bash
# Install dependencies
sudo apt update
sudo apt install -y unzip

# Download and install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

AWS CLI Configuration
# On Jenkins Server
aws configure
AWS Access Key ID: [YOUR_ACCESS_KEY]
AWS Secret Access Key: [YOUR_SECRET_KEY]
Default region name: [e.g., us-east-1]
Default output format: json
```

## Sonar-Scanner Installation

```bash
wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.8.0.2856.zip
unzip sonar-scanner-cli-4.8.0.2856.zip
sudo mv sonar-scanner-4.8.0.2856 /opt/sonar-scanner
export PATH=$PATH:/opt/sonar-scanner/bin
echo sonar-scanner --version
```

## Trivy Installation
```bash
sudo apt-get install wget gnupg
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy
```


## 2. Jenkins Installation and Configuration

### Jenkins Installation
```bash
# Update system
sudo apt update

# Install Java
sudo apt install openjdk-17-jre-headless

# Add Jenkins repository
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins

# Start Jenkins service
sudo systemctl status jenkins
```

### 2.2 Initial Jenkins Setup
```bash
# Retrieve initial admin password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

## Post-Installation Checks
```bash
# Verify installations
java -version
docker --version
jenkins --version
sonar-scanner --version
trivy --version
aws --version
```

## Troubleshooting Tips
- Check service status: `sudo systemctl status <service-name>`
- Restart services if needed

### Required Jenkins Plugins

#### Installation Process
1. Navigate to Jenkins Dashboard
2. Go to "Manage Jenkins" > "Plugins"
3. Click "Available Plugins"

#### Essential Plugins Installation List in Jenkins
- GitHub Integration
- Pipeline
- Docker Pipeline
- AWS Credentials
- CloudBees Docker
- Blue Ocean
- SonarQube Scanner
- Build Timestamp
- Pipeline Utility Steps


# Jenkins CI/CD Setup Guide

### 1.2 Configuring AWS Credentials in Jenkins

#### Method 1: AWS Credentials Plugin
1. Go to Jenkins Dashboard
2. Manage Jenkins > Manage Credentials
3. Click "System" > "Global credentials"
4. Click "Add Credentials"
5. Select "AWS Credentials"
6. Fill in:
   - ID: `aws-deployment-credentials`
   - Access Key ID: `[YOUR_AWS_ACCESS_KEY]`
   - Secret Access Key: `[YOUR_AWS_SECRET_KEY]`


## 2. GitHub Repository Integration

### 2.1 GitHub Webhook Setup
1. In your GitHub repository:
   - Settings > Webhooks
   - Add Webhook
   - Payload URL: `http://[JENKINS-SERVER-IP]:8080/github-webhook/`
   - Content Type: `application/json`
   - Events: Select "Push" and "Pull Request"


## 3. Creating Jenkins Pipeline Job

### 3.1 Create New Pipeline Job
1. Jenkins Dashboard > New Item
2. Enter Item Name: `[Your-Project-Name]-Pipeline`
3. Select "Pipeline" project type
4. Click "OK"


3. Pipeline Configuration:
   - Definition: "Pipeline script from SCM"
   - SCM: Git
   - Repository URL: `https://github.com/[USERNAME]/[REPO].git`
   - Credentials: Select GitHub credentials created earlier
   - Branch: `*/main` or `*/master`
   - Script Path: `Jenkinsfile`


## 4. Configuring SonarCloud Integration

### 4.1 SonarCloud Project Setup
1. Login to SonarCloud
2. Create Organization: `[Your-Organization]`
3. Create Project: `[Your-Project-Name]`
4. Generate Project Token

### 4.2 Jenkins SonarQube Configuration
1. Manage Jenkins > Configure System
2. Add SonarQube Servers
   - Name: SonarCloud
   - Server URL: `https://sonarcloud.io`
   - Server Authentication Token: Add SonarCloud token

## 5. Troubleshooting

### Common Issues
- Webhook not triggering
  - Check GitHub webhook settings
  - Verify Jenkins URL accessibility
- Credential issues
  - Validate AWS and GitHub credentials
- Build failures
  - Check console output for specific errors

# Jenkins Pipeline Configuration for ECS Deployment

## Jenkinsfile Environment Variables Configuration

### 1. Prerequisites
Before configuring the Jenkinsfile, ensure you have:
- AWS ECR Repository
- ECS Cluster and Service
- IAM Roles for ECS Task Execution
- Jenkins Credentials Setup

# Jenkinsfile Customization Guide for New Users

## 1. Environment Variables Customization

### Key Areas to Modify
```groovy
environment {
    // 1. Docker Image Names
    FRONTEND_IMAGE = "your-frontend-image:latest"
    DOCKER_IMAGE = "your-backend-image:latest"

    // 2. AWS Credentials
    AWS_ACCESS_KEY_ID = credentials('your-aws-access-key-credential-id')
    AWS_SECRET_ACCESS_KEY = credentials('your-aws-secret-key-credential-id')

    // 3. ECR Repository Details
    ECR_REPO = "your-account-id.dkr.ecr.your-region.amazonaws.com/your-repository-name"

    // 4. ECS Specific Configurations
    ECS_TASK_DEFINITION = "your-task-definition-name"
    ECS_CLUSTER = "your-ecs-cluster-name"
    ECS_SERVICE = "your-ecs-service-name"
    AWS_REGION = "your-preferred-aws-region"

    // 5. SonarCloud Project Details
    SONAR_PROJECT_KEY = "your-project-key"
    SONAR_ORG = "your-organization-key"
    SONAR_TOKEN = credentials('your-sonarcloud-token-credential-id')
}
```

## 2. Repository Configuration

### Modify Git Repository URL
```groovy
stage('Clone Repository') {
    steps {
        git branch: 'main', 
            url: 'https://github.com/your-username/your-repository.git'
    }
}
```

## 3. Docker Build Stages

### Customize Dockerfile Path and Image Name
```groovy
stage('Build Frontend Docker Image') {
    steps {
        script {
            sh """
            # Adjust Dockerfile path and build context
            docker build -t $FRONTEND_IMAGE \
                -f your-project/frontend/Dockerfile \
                your-project/frontend/
            """
        }
    }
}
```

## 4. AWS ECS Deployment Configuration

### Modify IAM Role and Task Definition
```groovy
stage('Update ECS Service') {
    steps {
        script {
            // Replace with your specific IAM Execution Role ARN
            def executionRoleArn = "arn:aws:iam::your-account-id:role/your-ecs-execution-role"

            // Customize container definition updates
            def updatedTaskDefinition = sh(script: """
                # Modify container name if different
                echo '$ecsTaskDefinition' | \
                jq -r '.taskDefinition.containerDefinitions | 
                map(if .name == "frontend" then .image = "$ECR_REPO:$BUILD_NUMBER" else . end)' | 
                jq -s '.[0]'
            """, returnStdout: true).trim()
        }
    }
}
```

## 5. SonarCloud Analysis Customization

### Adjust Source Scanning Parameters
```groovy
stage('SonarCloud Analysis') {
    steps {
        withSonarQubeEnv('SonarCloud') {
            sh '''
            sonar-scanner \
            -Dsonar.projectKey=$SONAR_PROJECT_KEY \
            -Dsonar.organization=$SONAR_ORG \
            -Dsonar.login=$SONAR_TOKEN \
            -Dsonar.sources=your-source-directory \
            -Dsonar.exclusions=**/test/**,**/*.spec.js
            '''
        }
    }
}
```
## On Successful Deployment Of Jenkins Pipeline Script

![alt text](ECS-DEPLOYMENT.png)

## Accessing Your ECS Load Balancer

After deploying your frontend application on Amazon ECS, the AWS load balancer provides the primary access point to your application.

### Finding Your Load Balancer URL

```bash
Open the AWS Management Console
Navigate to EC2 > Load Balancers
Select your load balancer from the list
Copy the DNS name from the "Description" tab 
(looks like: your-lb-name-123456789.region.elb.amazonaws.com)
```

### Verifying Your Application
Access your application by entering the load balancer DNS name in your browser. Your frontend should now be accessible through the loadbalancer URL.

## 6. Critical Customization Checklist

### Must-Check Items
- [ ] Update ECR Repository URL
- [ ] Verify AWS Credentials
- [ ] Confirm ECS Cluster and Service Names
- [ ] Check Dockerfile Paths
- [ ] Validate SonarCloud Project Details
- [ ] Adjust IAM Role ARNs
- [ ] Modify Repository URLs


This guide provides a comprehensive overview of the key areas we would need to modify in the Jenkinsfile, with specific attention to customization points, potential pitfalls, and best practices.======


# GitHub Actions ECS CI/CD Pipeline

This repository contains a CI/CD pipeline configuration for deploying applications to AWS ECS using GitHub Actions.

## Overview

The CI/CD pipeline automates the following processes:
- Code quality analysis using SonarCloud
- Docker image building for the frontend application
- Security scanning with Trivy
- Pushing images to Amazon ECR
- Deploying to AWS ECS (Fargate)

## Pipeline Architecture


The pipeline follows this workflow:
1. Code is pushed to the repository
2. Static code analysis is performed
3. Docker image is built and scanned for vulnerabilities
4. Image is pushed to Amazon ECR
5. ECS task definition is updated with the new image
6. ECS service is updated to use the new task definition

## GitHub Actions Workflow

The GitHub Actions workflow (`ecs-ci-cd.yml`) runs on pushes to the main branch and for pull requests:

```yaml
name: ECS CI/CD

on:
  push:
    branches:
      - dev
      - stage
    tags: # Triggers deployment to production on tags
      - 'v*'
  pull_request:
    types: [opened, synchronize, reopened]
    branches:
      - dev
      - stage
```

### Workflow Jobs

The workflow consists of the following jobs:
- **sonarcloud**: Performs static code analysis
- **docker-build**: Builds the Docker image, scans it for vulnerabilities, and pushes it to ECR
- **deploy-main**: Updates the ECS task definition and service

### Environment Variables

The workflow uses these environment variables:
- `AWS_REGION`: The AWS region for deployment
- `ECS_TASK_DEFINITION`: The name of the ECS task definition
- `ECS_CLUSTER`: The ECS cluster name
- `ECS_SERVICE`: The ECS service name
- `SONAR_PROJECT_KEY`: The SonarCloud project key
- `SONAR_ORG`: The SonarCloud organization

## Getting Started

### Prerequisites

- AWS account with permissions for ECR and ECS
- GitHub repository
- Docker installed on build servers
- SonarCloud account (optional)

### Setup for GitHub Actions

1. Fork or clone this repository
2. Set up the required secrets in your GitHub repository:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `ECR_REPO`
   - `SONAR_TOKEN`
   - `ECS_TASK_ROLE`

##  GitHub Repository Secrets Configuration

### Adding AWS Credentials to GitHub Secrets
1. Go to your GitHub repository
2. Navigate to Settings > Secrets and Variables > Actions
3. Click "New repository secret"

#### Create Secrets:
1. Secret:
   - Name: `AWS_ACCESS_KEY_ID`
   - Value: `[Your AWS Access Key]`

2. Secret:
   - Name: `AWS_SECRET_ACCESS_KEY`
   - Value: `[Your AWS Secret Access Key]`

3. Secret:
   - Name: `ECR_REPO`
   - Value: `[Your AWS ECR Value]`

4. Secret:
   - Name: `SONAR_TOKEN`
   - Value: `[Your Generated SONAR TOKEN]`

5. Secret:
   - Name: `ECS_TASK_ROLE`
   - Value: `[Your AWS ECS TASK ROLE ARN]`

![alt text](<Screenshot 2025-04-10 204337.png>)

NB: Customize the environment variables in the workflow file if needed, and also push to the main branch to trigger the workflow

## ON Successful Deployment To ECS via GitHub 

![alt text](<Screenshot 2025-04-10 205213.png>)

## Accessing Your ECS Load Balancer

After deploying your frontend application on Amazon ECS, the AWS load balancer provides the primary access point to your application.

### Finding Your Load Balancer URL

```bash
Open the AWS Management Console
Navigate to EC2 > Load Balancers
Select your load balancer from the list
Copy the DNS name from the "Description" tab 
(looks like: your-lb-name-123456789.region.elb.amazonaws.com)
```

### Verifying Your Application
Access your application by entering the load balancer DNS name in your browser. Your frontend should now be accessible through this URL.

## Security Considerations

The pipeline includes security best practices:
- Vulnerability scanning with Trivy
- Code quality analysis with SonarCloud
- Least privilege IAM permissions
- Secret management through GitHub Actions

## Troubleshooting

Common issues and solutions:

| Issue | Solution |
|-------|----------|
| Docker build fails | Check the Dockerfile and build context |
| Trivy reports vulnerabilities | Update base images or dependencies to fix security issues |
| Deployment fails | Verify AWS credentials and permissions |
| Service doesn't update | Check ECS task definition and service configuration |
| SonarCloud analysis fails | Verify SONAR_TOKEN and repository configuration |


# Kubernetes Application Deployment with Minikube

This guide covers the setup and dev deployment of a three-tier application (frontend, backend, database) using Kubernetes with Minikube on a Linux system. This is an intermediate-level guide that assumes prior knowledge of Kubernetes concepts.

## Prerequisites

- Linux operating system
- Docker Engine or Docker Desktop installed
- Minikube installed
- kubectl installed
- Git to clone this repository
- Understanding of Kubernetes concepts (Pods, Services, Deployments, PVs, PVCs)

## Setup Environment

### 1. Verify Docker Installation

```bash
docker --version
docker ps
```

Ensure Docker is running properly before proceeding.

### 2. Install Minikube (if not already installed on linux)

```bash
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
```

### 3. Start Minikube

```bash
minikube start --driver=docker

minikube start --cpus=4 --memory=8192 (This can be configured depending on your use cases.)

```

### 4. Verify Installation

```bash
minikube status
kubectl get nodes
```

## Project Structure

The project contains the following Kubernetes manifest files:

- `namespace.yaml` - Defines the namespace for our application
- `configmap.yaml` - Contains configuration for our application
- `database-storage.yaml` - PV and PVC for database persistence
- `database-deployment.yaml` - PostgreSQL database deployment
- `database-service.yaml` - Service for the database
- `backend-deployment.yaml` - Backend application deployment
- `backend-service.yaml` - Service for the backend
- `frontend-deployment.yaml` - Frontend application deployment
- `frontend-service.yaml` - Service for the frontend (will need modification)
- `frontend-autoscaler.yaml` - HPA for frontend scaling

## Pre-Deployment Steps

### 1. Create Local Storage Directory

Before deploying, create a directory on your host machine for database persistence:

```bash
mkdir -p ~/mnt/data/db
```

This directory will be mounted as a persistent volume for the database.

### 2. Build and Push Custom Docker Images

Due to the specific PostgreSQL setup with custom passwords, you'll need to build your own Docker images:


# Docker Compose for Building and Pushing Images

This section covers how to use Docker Compose to build your application images and push them to Docker Hub for use in your Kubernetes deployment.

### 2. Build Images Using Docker Compose

Build all the images at once:

```bash
docker compose build

OR 

docker compose up -d
```

## Push Images to Docker Hub

### 1. Login to Docker Hub

Before pushing your images, login to Docker Hub:

```bash
docker login
```

Enter your Docker Hub username and password when prompted.

### 2. Tag and Push Images

After successful login, tag and push your images to Docker Hub:

#### Frontend Image

```bash
docker tag 3-tier-web-architecture-frontend:latest holadmex/3-tier-web-architecture-frontend:latest
docker push holadmex/3-tier-web-architecture-frontend:latest
```

#### Backend Image

```bash
docker tag 3-tier-web-architecture-backend:latest holadmex/3-tier-web-architecture-backend:latest
docker push holadmex/3-tier-web-architecture-backend:latest
```

#### Database Image

```bash
docker tag 3-tier-web-architecture-database:latest holadmex/3-tier-web-architecture-database:latest
docker push holadmex/3-tier-web-architecture-database:latest
```

## Update Kubernetes Manifest Files

After pushing your images to Docker Hub, update your Kubernetes manifest files to reference these images:

### Update `frontend-deployment.yaml`

```yaml
spec:
  containers:
  - name: frontend
    image: holadmex/3-tier-web-architecture-frontend:latest
```

### Update `backend-deployment.yaml`

```yaml
spec:
  containers:
  - name: backend
    image: holadmex/3-tier-web-architecture-backend:latest
```

### Update `database-deployment.yaml`

```yaml
spec:
  containers:
  - name: database
    image: holadmex/3-tier-web-architecture-database:latest
```

## Testing with Docker Compose Before Kubernetes Deployment

You can test your entire application stack locally using Docker Compose before deploying to Kubernetes:

```bash
# Start the entire stack
docker-compose up -d

# Check if all services are running
docker-compose ps

# Check logs
docker-compose logs -f

# Test the application
curl http://localhost:3000

# Shut down the stack
docker-compose down
```


### 3. Update Image References in Manifest Files

Update the image references in your deployment files to point to your custom images:

- `database-deployment.yaml`: Update `image: yourusername/postgres-custom:latest`
- `backend-deployment.yaml`: Update `image: yourusername/backend:latest`
- `frontend-deployment.yaml`: Update `image: yourusername/frontend:latest`

### 4. Modify Frontend Service Type

For Minikube, change the service type in `frontend-service.yaml` from LoadBalancer to NodePort:

```yaml
# Original
spec:
  type: LoadBalancer
  
# Modified for Minikube
spec:
  type: NodePort
```

## Deployment Steps

### 1. Create Namespace

```bash
kubectl apply -f namespace.yaml
```

### 2. Apply ConfigMap

```bash
kubectl apply -f configmap.yaml
```

### 3. Set Up Database Storage

```bash
kubectl apply -f database-storage.yaml
```

### 4. Deploy Database

Before deploying, make sure to check the PVC configuration in `database-deployment.yaml`. If you encounter issues with PVC being already in use, you'll need to modify the volume configuration as explained in the Troubleshooting section.

```bash
kubectl apply -f database-deployment.yaml
kubectl apply -f database-service.yaml
```

### 5. Deploy Backend

```bash
kubectl apply -f backend-deployment.yaml
kubectl apply -f backend-service.yaml
```

### 6. Deploy Frontend

```bash
kubectl apply -f frontend-deployment.yaml
kubectl apply -f frontend-service.yaml
kubectl apply -f frontend-autoscaler.yaml
```

## To deploy the whole Kubernetes manifest file all at once.

```bash
kubectl create -f .
```

## Troubleshooting

### PVC Already in Use Error

If you encounter an error indicating that the PVC is already in use, you need to modify the volume configuration in `database-deployment.yaml`:

**Original configuration:**
```yaml
volumes:
  - name: db-storage
    persistentVolumeClaim:
      claimName: db-pvc
```

**Modified configuration:**
```yaml
volumes:
  - name: db-storage
    emptyDir: {}
```

This change uses an `emptyDir` volume instead of a PVC. Note that `emptyDir` is ephemeral and data will be lost when the pod is deleted.

### Database Pod Not Starting

If the database pod is not starting, check the logs:

```bash
kubectl get pods -n <your-namespace>
kubectl logs <database-pod-name> -n <your-namespace>
```

Common issues include:
- Incorrect PostgreSQL password configuration
- PV/PVC mounting issues
- Insufficient resources

### Backend Pod Not Starting

Backend pods may fail to start if they can't connect to the database:

```bash
kubectl logs <backend-pod-name> -n <your-namespace>
```

Ensure that the database is running and accessible:

```bash
kubectl get svc -n <your-namespace>
```

### Checking Pod Dependencies

Verify that your backend waits for the database to be ready:

```bash
kubectl describe pod <backend-pod-name> -n <your-namespace>
```

Look for init containers or readiness probes that might be failing.

### Pod Status Debugging

```bash
kubectl get pods -n <your-namespace>
kubectl describe pod <pod-name> -n <your-namespace>
kubectl logs <pod-name> -n <your-namespace>
```

## Accessing the Application

### Access Frontend Web Page

After deployment, you can access the frontend using Minikube's service command:

```bash
minikube service frontend-service -n <your-namespace>
```

This will automatically open your browser with the correct URL and port.

Alternatively, get the URL and port manually:

```bash
minikube service frontend-service -n <your-namespace> --url
```

### Port Forwarding (Alternative Method)

You can also use port forwarding to access the services:

```bash
# For frontend
kubectl port-forward svc/frontend-service 8080:80 -n <your-namespace>

# For backend API
kubectl port-forward svc/backend-service 3000:3000 -n <your-namespace>
```

Then access the frontend at `http://localhost:8080` and the backend at `http://localhost:3000`.

## Advanced Debugging


### Check Resource Usage

```bash
kubectl top nodes
kubectl top pods -n <your-namespace>
```

### Check Logs for All Containers

```bash
kubectl logs -f deployment/frontend -n <your-namespace>
kubectl logs -f deployment/backend -n <your-namespace>
kubectl logs -f deployment/database -n <your-namespace>
```

## Clean Up

When you're done with the application, clean up the resources:

```bash
kubectl delete -f frontend-autoscaler.yaml
kubectl delete -f frontend-service.yaml
kubectl delete -f frontend-deployment.yaml
kubectl delete -f backend-service.yaml
kubectl delete -f backend-deployment.yaml
kubectl delete -f database-service.yaml
kubectl delete -f database-deployment.yaml
kubectl delete -f database-storage.yaml
kubectl delete -f configmap.yaml
kubectl delete -f namespace.yaml

OR

kubectl delete all -f .

# Stop Minikube
minikube stop

# Optional: Delete the Minikube cluster
minikube delete
```

## Detailed Explanation of Manifest Files

### namespace.yaml
Creates a dedicated namespace for our application, ensuring resource isolation.

### configmap.yaml
Contains configuration data like database connection strings, environment variables, and application settings.

### database-storage.yaml
Defines the PersistentVolume (PV) and PersistentVolumeClaim (PVC) for database storage.

### database-deployment.yaml
Deploys the PostgreSQL database with proper configuration and volume mounting.

### database-service.yaml
Creates a ClusterIP service for internal database access.

### backend-deployment.yaml
Deploys the backend application, which depends on the database.

### backend-service.yaml
Creates a service for the backend API.

### frontend-deployment.yaml
Deploys the frontend application, typically a web UI.

### frontend-service.yaml
Creates a NodePort service (modified from LoadBalancer) for accessing the frontend.

### frontend-autoscaler.yaml
Horizontal Pod Autoscaler for scaling the frontend based on resource usage.

## Best Practices

1. Always ensure your database is properly backed up, especially when using emptyDir
2. Use resource limits and requests to ensure proper scheduling
3. Implement health checks for all pods
4. Use ConfigMaps and Secrets for configuration rather than hardcoding values
5. Always test changes in a development environment before applying to production


# Advanced Kubernetes Deployment with Kops and ELK Stack Monitoring

This section expands on our guide to cover production-level Kubernetes cluster setup using kops on AWS EC2 instances, deploying our application with proper LoadBalancer configuration, and implementing ELK stack monitoring using Ansible.

## Production Deployment with kops on AWS

### Prerequisites

- AWS account with proper IAM permissions
- EC2 instance to run kops commands
- AWS CLI configured with appropriate credentials
- Domain name (for kops DNS configuration)
- SSH key pair for node access

### Setting Up kops on EC2

1. Launch an EC2 instance (recommended t3.medium or larger)

2. Install kops, kubectl, and AWS CLI:

## AWS CLI

```bash
# Install dependencies
sudo apt update
sudo apt install -y unzip

# Download and install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

AWS CLI Configuration
# On Local Laptop/PC
aws configure
AWS Access Key ID: [YOUR_ACCESS_KEY]
AWS Secret Access Key: [YOUR_SECRET_KEY]
Default region name: [e.g., us-east-1]
Default output format: json
```

## Kubectl

```bash
# Download and install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
ls - (./kubectl)
chmod +x ./kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
sudo mv kubectl /usr/local/bin/
kubectl --help 
```

## Kops

```bash
# Download and install kops
wget https://github.com/kubernetes/kops/releases/download/v1.26.4/kops-linux-amd64
ls - (kops.linux.amd64)
chmod +x kops-linux-amd64
sudo mv kops-linux-amd64 /usr/local/bin/kops
kops --help
```

4. Create an S3 bucket for kops state store in your AWS account <kops-test-1>:

### Creating a Production Kubernetes Cluster

1. Create the cluster configuration on the kops Ec2 instance:

```bash
kops create cluster --name=dev.holadmexbobpro.online \
  --state=s3://kops-test-1 \
  --zones=us-east-1a,us-east-1b \
  --node-count=4 --node-size=t2.medium --master-size=t2.medium \
  --dns-zone=dev.holadmexbobpro.online \
  --node-volume-size=12 --master-volume-size=16 \
  --ssh-public-key ~/.ssh/id_ed25519.pub
```


2. Update the cluster after creation:

```bash
kops update cluster --name=dev.holadmexbobpro.online --state=s3://kops-test-1 --yes --admin
```

3. Validate the cluster:

```bash
kops validate cluster --state=s3://kops-test-1 --wait 10m
```

## Deploying Application with LoadBalancer on Production Cluster

1. Navigate to your manifest directory:

```bash
cd k8s-manifest
```

2. Apply the namespace config:

```bash
kubectl apply -f namespace.yaml
```

3. Apply the rest of your manifests, making sure to use the LoadBalancer type for frontend:

```bash
# Make sure frontend-service.yaml has LoadBalancer type
cat frontend-service.yaml

# It should have:
spec:
  type: LoadBalancer

# Apply all configs
kubectl apply -f configmap.yaml
kubectl apply -f database-storage.yaml
kubectl apply -f database-deployment.yaml
kubectl apply -f database-service.yaml
kubectl apply -f backend-deployment.yaml
kubectl apply -f backend-service.yaml
kubectl apply -f frontend-deployment.yaml
kubectl apply -f frontend-service.yaml
kubectl apply -f frontend-autoscaler.yaml
```

## To deploy the whole Kubernetes manifest file all at once.

```bash
kubectl create -f .
```

4. Check that the AWS LoadBalancer is provisioned:

```bash
kubectl get svc -n <your-namespace>
```

You should see an external IP assigned to your frontend service, which will be the AWS ELB endpoint.


## Accessing Your ECS Load Balancer

After deploying your frontend application on Amazon EC2 Kops Instance, the AWS load balancer provides the primary access point to your application.

### Finding Your Load Balancer URL

```bash
Open the AWS Management Console
Navigate to EC2 > Load Balancers
Select your load balancer from the list
Copy the DNS name from the "Description" tab 
(looks like: your-lb-name-123456789.region.elb.amazonaws.com)
```

### Verifying Your Application
Access your application by entering the load balancer DNS name in your browser. Your frontend should now be accessible through this URL.


# Setting Up ELK Stack Monitoring with Ansible

## Overview
This repository contains the necessary configurations to deploy an ELK (Elasticsearch, Logstash, Kibana) stack on Kubernetes using Ansible for automated provisioning.

## Prerequisites
- Ansible installed on your local machine
- Access to Kubernetes cluster
- SSH access to your master node

## Installation

### 1. Install Required Dependencies
```bash
sudo apt install ansible
sudo apt update
sudo apt install python3-pip
```

### 2. Configure Ansible Environment
Navigate to the Ansible directory structure:
```bash
cd ansible
ls -la  # Review directory structure containing inventory, playbooks, and roles
```

### 3. Prepare Kubernetes Environment
For testing purposes only, remove the control-plane taint from the master node:
```bash
kubectl taint nodes i-07914313fc69a09b7 node-role.kubernetes.io/control-plane:NoSchedule-
```
**Note:** This is not recommended for production environments.

### 4. Update Ansible Inventory
```bash
cd inventory
vi inventory
```

Configure your inventory with appropriate host details:
```yaml
all:
  hosts:
    k8s-master:
      ansible_host: 50.19.156.2  # Replace with your EC2 instance IP
      ansible_user: ubuntu
      ansible_ssh_private_key_file: ~/.ssh/id_ed25519
      ansible_python_interpreter: /usr/bin/python3
      ansible_env:
        KUBECONFIG: ~/.kube/config
```

## Deployment

### 1. Execute Ansible Playbook
```bash
cd ..  # Return to ansible directory
ansible-playbook -i inventory/inventory.yaml playbooks/stack-installation.yaml
```

### 2. Verify Deployment
Confirm that all ELK stack components are running:
```bash
kubectl get pods -n monitoring
kubectl get pods -n logging
```

## Accessing Web Interfaces

### Kibana
Check Kibana service details:
```bash
kubectl get svc kibana -n monitoring
kubectl get svc kibana -n logging
```

### Authentication Details

#### Grafana
- Default username: `admin`
- Retrieve password:
  ```bash
  kubectl get secret grafana -n monitoring -o yaml
  echo "dUZ2YlhMZjA1ZVUyZkFYUQ==" | base64 --decode
  ```

#### Kibana
- Default username: `elastic`
- Retrieve password:
  ```bash
  kubectl get secrets -n logging
  kubectl get secret elasticsearch-master-credentials -n logging -o jsonpath="{.data}" | jq
  kubectl get secret <elasticsearch-secret-name> -n logging -o jsonpath="{.data.elastic}" | base64 --decode
  ```

# Network Configuration for ELK Stack Components

## Step 1: Identify Required Ports

First, determine the NodePort values assigned to each service:

```bash
# List all services with their assigned ports
kubectl get svc -n monitoring
kubectl get svc -n logging
```

Example output:
```
NAME                      TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
grafana                   NodePort    10.100.200.15    <none>        3000:30300/TCP   1h
prometheus-server         NodePort    10.100.200.20    <none>        9090:30900/TCP   1h
kibana                    NodePort    10.100.200.25    <none>        5601:30601/TCP   1h
elasticsearch             NodePort    10.100.200.30    <none>        9200:30920/TCP   1h
```

Note the NodePort values (e.g., 30300, 30900, 30601, 30920).


### Using AWS Console

1. Open the AWS Management Console
2. Navigate to EC2 > Security Groups
3. Select the security group identified in Step 2
4. Click "Edit inbound rules"
5. Add rules for each service:
   - Type: Custom TCP
   - Port range: [NodePort value]
   - Source: Anywhere-IPv4 (0.0.0.0/0) or your specific IP range
   - Description: Service name (e.g., "Grafana NodePort")

6. Click "Save rules"


Once you've configured the security group rules to allow traffic to the NodePorts, you can access each component of the ELK stack using the master node's public IP address.


## Step 1: Access Each Component

### Grafana
```
http://<MASTER_NODE_EC2_PUBLIC_IP>:30300
```

### Prometheus
```
http://<MASTER_NODE_EC2_PUBLIC_IP>:30900
```

### Kibana
```
http://<MASTER_NODE_EC2_PUBLIC_IP>:30601
```


## Comparison: Minikube vs. kops Production Deployment

| Feature | Minikube | kops Production |
|---------|----------|----------------|
| Purpose | Development/Testing | Production-ready |
| Node Management | Single node | Multi-node, HA |
| Load Balancer | NodePort + manual access | AWS ELB integration |
| Storage | Local disk/hostPath | AWS EBS, EFS |
| Scalability | Limited | Auto-scaling supported |
| Monitoring | Manual setup | Ansible + ELK integration |
| Cost | Free (local resources) | AWS infrastructure costs |
| Security | Basic | IAM integration, network policies |