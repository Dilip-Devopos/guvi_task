## EKS NGINX Deployment Project
This project demonstrates how to set up an Amazon EKS (Elastic Kubernetes Service) cluster using eksctl, deploy an NGINX application, expose it to the internet using a LoadBalancer service, and access it externally. All operations were done from an EC2 instance on AWS.

📋 Prerequisites
- An AWS account with EC2 access
- Permissions to create IAM roles, VPCs, EKS   clusters, and load balancers
- An Amazon EC2 Linux instance (Ubuntu preferred)
Step 1: create a EC2 instance with ami= ubuntu type=t2.medium & login
Step 2: Create an IAM Role with Permissions
   Go to AWS IAM Console:
   https://console.aws.amazon.com/iam/

   Create a Role:
   Click Roles > Create role
   Select AWS service as trusted entity
   Use case: EC2
   Click Next
   Attach Policies:
   Attach the following permissions:
       AmazonEC2FullAccess
       AmazonEKSClusterPolicy
       AmazonEKSWorkerNodePolicy
       AmazonEKS_CNI_Policy
       AmazonSSMManagedInstanceCore

   AdministratorAccess (optional, if full access is fine)
   Name the Role: e.g., EC2-EKS-AdminRole
   Create Role

⚙️ Tools Installed
From the EC2 instance, the following tools were installed:

1. kubectl (Kubernetes CLI)    
- curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl       
- chmod +x ./kubectl   
- sudo mv ./kubectl /usr/local/bin
2. eksctl (EKS Cluster Management CLI)
- curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
- sudo mv /tmp/eksctl /usr/local/bin
3. AWS CLI
- sudo apt install zip -y
- curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
- unzip awscliv2.zip
- sudo ./aws/install
🚀 Creating the EKS Cluster
Using eksctl, an EKS cluster was created:
- eksctl create cluster --name guvi-task \
   --region us-east-1 \
   --node-type t2.medium
This command provisions the EKS control plane and worker nodes in the specified region with the default node group.

🧠 Verifying Cluster Setup
Once the cluster was created:
- kubectl get nodes: 
This command shows the registered nodes in the cluster to confirm successful setup.
📦 Deploying NGINX
Deploy the NGINX application using the Kubernetes Deployment controller:
- kubectl create deployment nginx --image=nginx --port=80    

🌐 Exposing the Application
To expose the NGINX deployment to the internet using a LoadBalancer:
- kubectl expose deployment nginx --type=LoadBalancer --port=80     
- kubectl get services
- Copy the  DNS name and access it from a browser
- You should see the default NGINX welcome page.

🧹 Cleaning Up
To avoid incurring charges, delete the EKS  cluster
- eksctl delete cluster --name guvi-task --region us-east-1

Note: All the practical screenshots are kept under output_screenshots folder for reference.