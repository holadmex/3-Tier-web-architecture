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

## Docker Containerization of both Frontend and Backend

```bash
cd frontend

# Build the frontend Docker image
docker build -t frontend .

# Run the frontend container
docker run -d --name web -p 80:80 frontend
```

```bash
cd backend

# Build the backend Docker image
docker build -t backend .

# Run the backend container
docker run -d --name web -p 5000:5000 backend
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

## 6. Critical Customization Checklist

### Must-Check Items
- [ ] Update ECR Repository URL
- [ ] Verify AWS Credentials
- [ ] Confirm ECS Cluster and Service Names
- [ ] Check Dockerfile Paths
- [ ] Validate SonarCloud Project Details
- [ ] Adjust IAM Role ARNs
- [ ] Modify Repository URLs

## 7. Common Pitfalls to Avoid
- Using hardcoded credentials
- Incorrect file paths
- Mismatched container names
- Overlooking AWS region settings
- Not setting up proper Jenkins credentials

## 8. Recommended Approach
1. Start with small, incremental changes
2. Test each stage separately
3. Use Jenkins pipeline syntax validation
4. Verify credentials and permissions
5. Run initial builds with verbose logging


This guide provides a comprehensive overview of the key areas we would need to modify in the Jenkinsfile, with specific attention to customization points, potential pitfalls, and best practices.======



