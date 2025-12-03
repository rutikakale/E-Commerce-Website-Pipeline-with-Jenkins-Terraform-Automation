# 🛒 E-Commerce Website Deployment on AWS 🚀

A **full-stack Spring Boot E-Commerce application** deployed on **AWS EC2** with **MySQL RDS** using **Terraform** for infrastructure provisioning and **Jenkins CI/CD** for automated build and deployment.

This project demonstrates modern DevOps practices, including **Infrastructure as Code**, **Continuous Integration**, and **Continuous Deployment** for cloud-ready applications.

---

## 🌟 Project Highlights

- **Automated CI/CD Pipeline:** Jenkins handles build, test, and deployment automatically on every code push.  
- **Infrastructure as Code:** Terraform scripts provision EC2 instances, MySQL RDS, security groups, and IAM roles.  
- **Cloud Deployment:** Application is hosted on AWS EC2 and connected to RDS for persistent data storage.  
- **Production Ready:** Scalable, secure, and maintainable architecture.  
- **Modern Tech Stack:** Java Spring Boot, MySQL, AWS, Terraform, Jenkins, GitHub.

---

## 🏗 Architecture Diagram

![E-Commerce Architecture](./IMG/Spring%20Boot%20Infrastructure%20Deployment%20Diagram.png)

**Architecture Flow:**  
1. Code pushed to GitHub repository triggers **Jenkins pipeline** via webhook.  
2. Jenkins builds the Spring Boot application using **Maven**, runs tests, and packages the app.  
3. Terraform provisions **EC2**, **RDS**, and required networking/security configurations.  
4. Jenkins deploys the packaged application to the EC2 instance.  
5. Application connects to **MySQL RDS** for database operations.  

---

## 💻 Tech Stack

| Layer               | Technology                          |
|--------------------|------------------------------------|
| Backend             | Java Spring Boot                    |
| Database            | MySQL RDS                          |
| Cloud               | AWS EC2, RDS                        |
| CI/CD               | Jenkins, GitHub Webhook            |
| Infrastructure IaC  | Terraform                           |
| Version Control     | Git & GitHub                        |
| Build Tool          | Maven                               |
| OS                  | Ubuntu / Linux                       |

---

## ⚡ Features

- Fully automated **CI/CD deployment**.  
- EC2-hosted **Spring Boot application**.  
- Secure and scalable **MySQL RDS database**.  
- GitHub Webhook triggers Jenkins for automatic deployment.  
- Terraform IaC for **repeatable, consistent infrastructure**.  
- Easy-to-manage cloud architecture with best practices.  

---

## 🖼 Screenshots

![](./IMG/terraform.jpg)

### Jenkins Pipeline
![Jenkins Pipeline](./IMG/jenkins%20pipeline.jpg) 

### Terraform Deployment
![Terraform Infrastructure](./IMG/terraform%20deployment.png) 

> Replace these placeholders with your actual screenshots from the project.

---

## 🚀 Setup Instructions

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/rutikakale/E-Commerce-Website-Pipeline-with-Jenkins-Terraform-Automation.git
cd ecommerce-terraform-jenkins
```
### 2️⃣ Terraform Infrastructure Deployment
```bash
cd terraform
terraform init
terraform plan
terraform apply
```
Provisions EC2, RDS, security groups, and IAM roles.

### 3️⃣ Jenkins CI/CD Setup
* Install required plugins: Git, Maven, Pipeline, SSH Agent.

* Create a pipeline job using the Jenkinsfile in the repo.

* Configure GitHub webhook for automatic trigger on push.

### 4️⃣ Deploy Spring Boot Application

* Jenkins builds the project using Maven and deploys it to EC2.

* Access your E-Commerce website via the EC2 public IP.

### 🔄 CI/CD Workflow
1. Code Commit: Push changes to GitHub repository.

2. Webhook Trigger: GitHub webhook triggers Jenkins pipeline.

3. Build Stage: Jenkins builds Spring Boot app using Maven.

4. Test Stage: Run unit tests (optional).

5. Deploy Stage: Deploy the app to EC2 and configure environment.

6. App Live: Application runs on EC2 and connects to RDS for database operations.

### 📌 Notes & Best Practices
* Update `terraform/variables.tf` with AWS credentials, DB password, and region.

* Ensure EC2 security group allows inbound HTTP/SSH traffic.

* Ensure RDS security group allows EC2 instance to connect.

* Replace placeholder images with actual screenshots for GitHub display.

* Keep Jenkins credentials and sensitive information secure using Jenkins credentials plugin.

### 📈 Project Status
✅ Completed & Fully Functional

* Infrastructure provisioning automated

* Application deployed via Jenkins pipeline

* CI/CD workflow tested successfully


