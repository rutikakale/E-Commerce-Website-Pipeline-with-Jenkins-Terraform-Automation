# E-commerce Project — Deployment 

This project automates the deployment of a Spring Boot E-commerce application using Terraform, Jenkins, EC2, and AWS RDS.
Terraform creates the required AWS infrastructure, including EC2 for the app and RDS for the database.
Jenkins handles the CI/CD pipeline — pulling code from GitHub, building it with Maven, and deploying the final JAR to EC2 automatically using SSH.
GitHub Webhooks ensure every code push triggers the pipeline.
The result is a fully automated, end-to-end deployment setup.

![](./img/overview.png)
---

## Repository
Clone the repository:

```bash
git clone https://github.com/dalvipiyush07/E-commerce-project-springBoot.git
cd E-commerce-project-springBoot
```

The Maven Spring Boot project is inside the `JtProject/` folder.

---

## 1. Terraform — EC2 + RDS launch

Files :- `main.tf`, `terraform.tfvars`

Important variables (`terraform.tfvars`)
```bash
public_key_path = "C:/Users/Piyush/Downloads/newin.pub"
db_password = "YourStrongDBPassword"
my_ip_cidr = "203.x.x.x/32" # SSH access
instance_type = "t3.micro"
db_name = "ecomdb"
db_username = "appuser"
allocated_storage = 20
```
Commands :- 
```bash
terraform init -upgrade
terraform plan -var-file="ec2.tfvars"
terraform apply -var-file="ec2.tfvars"
```

![](./img/ec2.png)

---

## 2. Jenkins Setup

Required Plugins:
- Pipeline
- Git
- GitHub 
- SSH Agent

Credentials:
- SSH Username with private key
- Username: ubuntu  
- ID: web-key

### Add Credentials (Jenkins → Credentials → System → Global credentials)

SSH Username with private key

ID: `web-key` (example)

Username: `ubuntu`

Private Key: paste your PEM private key

(Optional) GitHub token credential if repo is private.
---

## 4. Jenkinsfile

```groovy
pipeline {
  agent any
  environment {
    GITHUB_REPO_URL = "https://github.com/dalvipiyush07/E-commerce-project-springBoot.git"
    GIT_BRANCH = "master2"
    SSH_CRED_ID = "web-key"
    EC2_IP = "<EC2_PUBLIC_IP>"
    REMOTE_USER = "ubuntu"
    APP_PATH = "/opt/ecom-app"
    PROJECT_DIR = "JtProject"
  }
  stages {
    stage('Checkout Code') { steps { git url: "${GITHUB_REPO_URL}", branch: "${GIT_BRANCH}" } }
    stage('Build with Maven') {
      steps { dir("${PROJECT_DIR}") { sh "mvn -B clean package -DskipTests" } }
      post { success { archiveArtifacts artifacts: "${PROJECT_DIR}/target/*.jar", fingerprint: true } }
    }
    stage('Deploy to EC2') {
      steps {
        sshagent(credentials: [SSH_CRED_ID]) {
          script {
            def jarFile = sh(script: "ls ${PROJECT_DIR}/target/*.jar 2>/dev/null | head -n 1 || true", returnStdout: true).trim()
            if (!jarFile) { error "No JAR file found" }
            sh "ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${EC2_IP} 'sudo mkdir -p ${APP_PATH}'"
            sh "scp -o StrictHostKeyChecking=no "${jarFile}" ${REMOTE_USER}@${EC2_IP}:"${APP_PATH}/app.jar""
            sh "ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${EC2_IP} 'sudo systemctl restart ecom.service || true'"
          }
        }
      }
    }
  }
  post { always { deleteDir() } }
}
```
![](./img/commit.png)

---

## 5. GitHub Webhook Setup

Go to:  
GitHub → Repository → Settings → Webhooks → Add webhook  
Payload URL:

```
http://<JENKINS_URL>/github-webhook/
```

Event: push  
Content type: application/json

---
![](./img/github.png)

## 6. Jenkins Build Output

Monitor Jenkins console output to verify:
- Git checkout
- Maven build success
- Deployment to EC2

---
![](./img/output.png)

## Troubleshooting quick tips

1.Git clone fails → Check branch name (master2 in this repo).

2.Jenkins cannot ssh to EC2 → Verify credential ID and that private key is correct & ubuntu user allowed.

3.Port refused → Check associate_public_ip_address, security group inbound rules for 8080/22/80.

4.RDS DB connection fails → Verify DB security group allows EC2 SG and correct DB credentials in app application.properties.

## Useful commands summary

```bash
# Terraform
terraform init -upgrade
terraform plan -var-file="ec2.tfvars"
terraform apply -var-file="ec2.tfvars"


# SSH to EC2
ssh -i /path/to/newin.pem ubuntu@<EC2_IP>


# Jenkins service
sudo systemctl status jenkins
sudo journalctl -u jenkins -f


# Restart app service on EC2
sudo systemctl restart ecom.service
sudo journalctl -u ecom.service -f
```

## Author  
Piyush Dalvi
