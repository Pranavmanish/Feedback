SWE645 - Assignment 2
-----------------------
Overview:
This repository contains the solution for SWE645 Assignment 2. The project involves containerizing a web application (from Homework 1 - Part 2) using Docker, deploying it on a Kubernetes cluster for scalability and resiliency, and setting up a CI/CD pipeline with GitHub and Jenkins.
The repository includes the following key components:
1.Dockerfile - Builds the Docker image for the web application.
2.deployment.yaml - Kubernetes deployment configuration with three replicas.
3.service.yaml - Kubernetes service configuration to expose the application.
4.Jenkinsfile - Pipeline script to automate the build and deployment process.
5.feedback.html - The web application's source code (student survey form).
------------------------
Group Members:
Pranav Manish Reddi Madduri (G01504276): Containerization (Docker) and documentation.
Lavanya Jillella(G01449670): Kubernetes deployment and service configuration.
Sneha Rathi(G01449688): CI/CD pipeline configuration using Jenkins.
Chennu Naga Venkata Sai(G01514409): Testing, debugging, and integration.
-------------------------
Prerequisites:
Ensure you have the following installed:
1.Docker
2.Html files
3.AWS Account
4.Git for version control
-------------------------
Installation and Setup:
-------------------------
1. Generating a Docker Image

Clone the repository:
git clone <repository_url>
cd <repository_directory>

Build the Docker image using the provided Dockerfile:docker build -t pranav1706/feedback:latest .
Check if the image is working correctly by typing: docker run -it -p 8182:8080 pranav1706/feedback:latest
Open a web browser and go to "http://localhost:8182/pranav1706/" to check if the application runs properly.
Push the Docker image to your container registry: docker push pranav1706/feedback:latest
Ensure your image is uploaded to Docker Hub by logging into Docker Hub.We can also check for it in Docker Desktop on local machine.
Now we have successfully generated a Docker Image and pushed it to DockerHub.
------------------------
2. Kubernetes Deployment

Creating EC2 Instance 1 and Instance 2 in AWS:
In the AWS EC2 Instance Console, Select Launch Instance and Give an Instance name.
Select AMI as Ubuntu and Instance Type as: t2.medium.
In the Network Settings, Select Edit.
Under Inbound Security Group Rules, Select Add Security Group Rule and add 3 Security Group Rule as follows:
	a. Type: HTTP, Port Range: 80, Source Type: Custom, Source: 0.0.0.0/0
	b. Type: HTTPS, Port Range: 443, Source Type: Custom, Source: 0.0.0.0/0
	c. Type: Custom TCP, Port Range: 8080, Source Type: Custom, Source: 0.0.0.0/0
Under Configure Storage, set to 30 GiB, Select number of Instances as 2 and then Launch Instance.
Once the Instance starts Running, Go to ElasticIPs and associate ElasticIPs for Instance 1 and Instance 2 

Install Docker on both instances:
Update the packages using the following command: sudo apt update
Install docker using: sudo docker.io

Install Rancher on Instance 1:
Go to this website - rancher.io and Click on 'Get Started'
Copy the code given there: sudo docker run --privileged -d --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher
Run this command to view the current docker instance: sudo docker ps
Copy the container ID: 29d579dcbdcc
Go to Instance 1 -> click on the public IPv4 DNS address
Rancher will open for the first time and then Copy the command given on the page and run on Instance 1 (Insert Container ID copied before in this command):
sudo docker logs  container-id  2>&1 | grep "Bootstrap Password:"
Copy the password that appears after executing the command and paste it on the Rancher web page
Create a new password for Rancher on the next page
Thus Rancher is successfully installed.

Creating a New Cluster:
Go to Cluster Management and click on Create and then select RKE1 ,then Custom and Add cluster name and click next
Click on the etcd, Control Plane and Worked check-boxes, then copy the command given below
Run the copied command on Instance 2
Once the command has finished execution, click the Done button in Rancher
A provisioning cluster should appear in Rancher - wait till cluster is active
Once active, go to Rancher home and click on the cluster name
Then select Workload and then Deployments and Create
Increase replicas to 3
Container image name should be like: pranav1706/feedback:latest
Give name to Deployment
Click on Add Port and Service Type should be Load Balancer and Give a name to the Load Balancer and Set private container port (8080)
Click on Create, Wait until active
Once active, go to Service Discovery and click on Services and Click on the link

Update the image name in deployment.yaml if necessary.
Deploy the application on your Kubernetes cluster:
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

Verify the deployment:
kubectl get pods
Atleast three pods must be running.
-------------------------------------
3. CI/CD Pipeline Setup with Jenkins

Connect to Instance 1 via SSH and run the commands given below:
sudo apt update
sudo apt install openjdk-17-jdk
java -version
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins
systemctl status jenkins
sudo ufw allow 8080

Configuring Jenkins:
Run the Instance 1 URL 
sudo cat /var/lib/jenkins/secrets/initialAdminPassword (you can get the initial Admin credentials to login to jenkins for the firstime)
sudo apt install snapd
sudo snap install kubectl --classic
In Rancher click on your Cluster and then on 'Kubeconfig File' to download the Kubeconfig file
Open the browser and navigate to your instance's public IP address followed by port 8080 i.e :8080 (e.g. http://<elastic-ip>:8080).
Log in to the Jenkins and Install the plugins from Manage Jenkins and select Plugins:
	GitHub plugin
	Docker plugin
	Build Timestamp plugin
	Pipeline Stage View
Then, Select Install to install the Plugins.
Go to Manage Jenkins and click on Credentials,then select System and then Global credentials (unrestricted).
Set Credential for GitHub and for Docker.
Provide the kubeconfig file downloded earlier to credentials as a secret file (you can directly upload it from your local storage)
Click on New Item in the Jenkins Dashbord, enter name for the project and select 'Pipeline' and then Select Ok.
In the configurations select Git hub project and provide repository url
Select Poll SCM: and give * * * * * 
Select 'Pipeline script from SCM'.
In the 'SCM' section, select 'Git. Give the repository URL and select the Github credentials.
Set the branch as */main and then save.
Run this command on Instance 1: sudo chmod 777 /var/run/docker.sock
Configure your Jenkins server and install the necessary plugins (Docker, Kubernetes, Git).
Set up a Jenkins job using the provided Jenkinsfile. This file automates the stages for:
Building the Docker image.
Pushing the image to the container registry.
Deploying the application on Kubernetes.
Link your GitHub repository to the Jenkins job.
Trigger a build to verify the CI/CD pipeline and deployment.



k8s deployed Page link : https://18.210.215.5/k8s/clusters/c-xkpdm/api/v1/namespaces/default/services/http:feedback-service:80/proxy/

Rancher link: https://18.210.215.5/dashboard/home (Username- admin,password-Rancher.1719)

Jenkins link : http://52.203.38.107:8080/  (Username- pranav,password- pranav.1719)

Github repo: https://github.com/Pranavmanish/Feedback

Dockerhub repo: https://hub.docker.com/repository/docker/pranav1706/feedback/general

