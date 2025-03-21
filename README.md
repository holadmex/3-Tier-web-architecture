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

## Python

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

#### PostgreSQL Configuration File Modifications Before Connecting to Your Newly Created Database

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

Navigate to the frontend web page on your broswer, on the signup page on your web application, and create a user account. If everything is configured correctly, you should see a success message or be redirected to a login page.

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

## Containerization both frontend and backend

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

## Database Migration Management

Flask-Migrate helps manage database schema changes:

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

These steps will help you properly set up, run, and test your backend application, ensuring it connects correctly to the PostgreSQL database and responds to API requests as expected.


