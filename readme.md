# Simple Web App Deployment

This repo Demonstrates the set up and Deployment of a simple node app using Jenkins as CI/CD server , SonarQube as Static Analysis server with MySQL RDS database connected, Docker as Container Manager , AWS EC2 for Building and Deployment Environments , Kubernetes to run and manage Deployment cluster

# Architecture Diagram

![alt text](https://user-images.githubusercontent.com/25318440/90883289-d031e680-e3ad-11ea-8269-deb98ca8306d.png)

# Deployment Model

- Source Code Management  (github)
- Jenkins (CI/CD Server)
- SonarQube (Static Analysis Server)
- RDS MySQL (Connected to SonarQube to save reports)
- Docker (Pushing Succeeded Container Images to be pulled at Deployment)
- Ansible (Configuration Management for Deployment Environment and Jenkins Slave Nodes)
- Deployment Environment (Contains needed tools for Deployment )
- Kubernetes Cluster (for Deploying the app)

## Instructions for use

### Set Up Docker Image Manually (optional for manual deployment)
1. Fork the repo
2. Clone repo locally
3. Build Docker image `docker image build -t <tag> .` from within the root directory of the repo
4. Push image to container registry
5. Run container/Pod using the created image

### Create MySQL DB to work as SonarQube Database
1. Download Mysql if you want to run on local machine
2. create an AWS RDS if you want to use cloud architecture don't forget to allow security group to access SonarQube server


### Install SonarQube Server on a node (EC2 Instance)
1. Install SonarQube from https://www.sonarqube.org/downloads/
2. unzip SonarQube in /opt/sonar
3. install mysql client
4. connect to DB `mysql -h <RDS_Instance_endpoint>:3306 -u <DB_USER_NAME> -p <DB_PASSWORD> `
5. Create a new sonar database, local and remote users and give them access permissions
6. on SonarQube Server machine enable SonarQube properties file to connect his Database.
7. in file:opt/sonar/conf/sonar.properties under mysql configurations
  sonar.jdbc.username=sonar
  sonar.jdbc.password=sonar
  sonar.jdbc.url=jdbc:mysql://<RDS_DATABAE_ENDPOINT>:3306/sonar?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true&useConfigs=maxPerformance&useSSL=false
  sonar.web.host=0.0.0.0
  sonar.web.context=/sonar
8. Implement SonarQube server as a service `sudo cp /opt/sonar/bin/linux-x86-64/sonar.sh /etc/init.d/sonar`
9. edit etc/init.d/sonar file
`SONAR_HOME=/opt/sonar
PLATFORM=linux-x86-64

WRAPPER_CMD="${SONAR_HOME}/bin/${PLATFORM}/wrapper"
WRAPPER_CONF="${SONAR_HOME}/conf/wrapper.conf"
PIDDIR="/var/run"`
10. Start SonarQube service


### Set Up Jenkins nodes (AWS EC2 Instances)
1. Launch EC2 instance as a build node with tag test-EC2
2. Launch EC2 instance as a Deployment node with tag Deployment-EC2

### Set Up Jenkins server
1. On Your Jenkins Server set up your aws credentials by adding new credentials using Cloudbees AWS credentials plug-in
2. On Your Jenkins Server add the previous 2 nodes as Cloud Nodes using Cloudbees EC2 plug-in w
3. Add a new Job specifying this github repo to use the Jenkinsfile
4. On Jenkins Server Install SonarQube Scanner
5. Set SonarQube server details in sonar-scanner property file:  /opt/sonar_scanner/conf/sonar-scanner.properties
sonar.host.url=http://<SONAR_SERVER_IP>:9000 (localhost if Sonar server is on the same machine)
6. Install SonarQube scanner plugin and configure SONAR_RUNNER_HOME



### Set Up Deployment Environments
1. Connect to the Deployment EC2 instance to download the environment
2. Install kops , terraform , aws-cli , kubectl (you can use the attached deploymentPEnv.sh)
3. Run createEnv.tf file to create the needed Environment on AWS creating your cluster
4. createEnv.tf creates DNS Hosted Zone, VPC and a Security Group for the cluster
5. run kops create with --yes option and specify the needed options
6. check if cluster is healthy with kops validate cluster

### Set up Deployment Environment Using Terraform

1. Download needed tools (Kubectl , aws-cli , terraform , kops)
2. Create an s3 bucket to hold KOPS_STATE_STORE variable and export
   `export KOPS_STATE_STORE=s3://<kops_state_bucket>` # Get this values from test.tfvars
3. Execute `terraform init` to initialize terraform configurations and download dependencies
4. Execute `terraform plan -var-file=test.tfvars`
5. Execute `terraform apply -var-file=config/${env}.tfvars` and answer `yes` when prompted.
6. Once terraform is done you can check the state of the cluster with: `kops validate cluster`
8. For example `kubectl get nodes`
9. To destroy the environment simply run `terraform destroy -var-file=config/${env}.tfvars` and answer `yes` when prompted.

### Set up Kubernetes cluster
1. when cluster is up apply the web-deploy.yml (web-deploy.yml pulls previously built container and deploys it creating 3 replicas)
2. To allow the Web app to reached from outside a svc should be deployed , use web-lb.yml to deploy a loadbalancer on aws which would connect to kubernetes svc exposing port 80
3. connect to the application through loadbalancer EXTERNAL-IP:80
