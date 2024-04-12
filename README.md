Todo Node.js App Deployment Documentation.
Access Application->
for Dev: adex-dev-188381659.us-east-1.elb.amazonaws.com
for Prod: adex-task-alb-prod-627012683.us-east-1.elb.amazonaws.com

(Note: please refer branch name infra for dev)

1. Introduction
This documentation provides a detailed overview of the deployment process for the Todo Node.js application using modern DevOps practices. The deployment utilizes Docker containers orchestrated with AWS ECS Fargate, managed through Terraform, and automated with GitActions. The application is deployed in both development and production environments on AWS.

2. Project Overview
The Todo Node.js application aims to provide a simple and efficient task management system. The project's objectives include creating a scalable, resilient, and easily deployable application infrastructure.

3. Architecture Overview
The architecture consists of several components:

- Node.js App: Core application logic written in Node.js.
- Docker: Containerization platform used to package the application.
- AWS ECS Fargate: Orchestration service for running Docker containers without managing underlying infrastructure.
- AWS ALB: Application Load Balancer to distribute incoming traffic.
- Terraform: Infrastructure as Code tool used for provisioning AWS resources.
- GitActions: CI/CD pipeline for automating build, test, and deployment processes.

4. Technologies Used
- Node.js: JavaScript runtime for building the application backend.
- Docker: Containerization platform for packaging the application and its dependencies.
- AWS ECS Fargate: Serverless container orchestration service.
- AWS ALB: Application Load Balancer for distributing incoming traffic.
- Terraform: Infrastructure provisioning tool for managing AWS resources.
- GitActions: CI/CD platform for automating software development workflows.

5. Planning and Design
The planning phase involved:

- Gathering requirements and defining project goals.
- Designing the application architecture for scalability and availability.
- Planning the infrastructure setup using AWS ECS Fargate and ALB.
- Designing the CI/CD pipeline with GitActions for automated deployments.

6. Implementation Steps
The implementation involved the following steps:

- Dockerizing the Node.js Application
- Configured a Dockerfile to build the Node.js application image.
- Included necessary dependencies and defined the entry point for the container.
- Infrastructure Provisioning with Terraform
- Created Terraform configurations for AWS ECS Fargate, ALB, IAM roles, security groups, etc.
- Defined Terraform modules for reusable infrastructure components.
- Managed environment-specific configurations using Terraform workspaces.
- Setting up CI/CD with GitActions
- Configured GitActions workflows for automated testing and deployment.
- Defined pipeline stages for building, testing, and deploying to dev and prod environments.
- Integrated with AWS CLI for deploying Terraform changes.
- Deployment on AWS ECS Fargate
- Deployed the Dockerized application to AWS ECS Fargate using Terraform.
- Configured ECS task definitions, services, and clusters.
- Utilized ALB for routing traffic to ECS services.

7. Infrastructure as Code (IaC)
Terraform was chosen for managing infrastructure due to its declarative nature and support for AWS resources. The Terraform codebase includes:

- main.tf: Main configuration file defining AWS provider and resources.
- variables.tf: Declaration of input variables for customization.
- dev.tfvars: Declaration of input variables for dev environment
- prod.tfvars: Declaration of input variables for prod environment

8. Continuous Integration and Continuous Deployment (CI/CD)
GitActions provides automated CI/CD pipelines. The CI/CD workflow includes:

Build stage: Builds the Docker image and runs unit tests.
Test stage: Executes integration tests to ensure application functionality.
Deployment stage: Deploys the application to dev environment after successful tests.
Manual approval: Requires manual approval to promote the deployment to prod environment.

9. Security Considerations
Security measures implemented include:

- Restrictive IAM roles and policies for ECS tasks to minimize access.
- Security groups to control inbound and outbound traffic.
- TLS encryption enabled on ALB for secure communication.

10. Monitoring and Logging (Pending)
Monitoring and logging are crucial for maintaining application health and diagnosing issues. Implemented monitoring includes:
- Impletement Grafana and Prometheus 
- Use Cloudwatch and Event Bridge for monitoring and Alert system.
