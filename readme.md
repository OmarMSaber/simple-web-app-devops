# Simple Web App Deployment

This repo Demonstrates the set up and Deployment of a simple node app using Jenkins as CI/CD server , Docker as Container Manager , AWS EC2 for Building and Deployment Environments , Kubernetes to run and manage Deployment cluster


## Instructions for use

### Set Up Docker Image Manually (optional for manual deployment)
1. Fork the repo
2. Clone repo locally
3. Build Docker image `docker image build -t <tag> .` from within the root directory of the repo
4. Push image to container registry
5. Run container/Pod using the created image

### Set Up Jenkins nodes (AWS EC2 Instances)
1. Launch EC2 instance as a build node with tag test-EC2
2. Launch EC2 instance as a Deployment node with tag Deployment-EC2

### Set Up Jenkins server
1. On Your Jenkins Server set up your aws credentials by adding new credentials using Cloudbees AWS credentials plug-in
2. On Your Jenkins Server add the previous 2 nodes as Cloud Nodes using Cloudbees EC2 plug-in w
3. Add a new Job specifying this github repo to use the Jenkinsfile

### Set Up Deployment Environments
1. Connect to the Deployment EC2 instance to download the environment
2. Install kops , terraform , aws-cli , kubectl (you can use the attached deploymentPEnv.sh)
3. Run createEnv.tf file to create the needed Environment on AWS creating your cluster
4. createEnv.tf creates DNS Hosted Zone, VPC and a Security Group for the cluster
5. run kops create with --yes option and specify the needed options
6. check if cluster is healthy with kops validate cluster

### Set up Kubernetes cluster
1. when cluster is up apply the web-deploy.yml (web-deploy.yml pulls previously built container and deploys it creating 3 replicas)
2. To allow the Web app to reached from outside a svc should be deployed , use web-lb.yml to deploy a loadbalancer on aws which would connect to kubernetes svc exposing port 80
3. connect to the application through loadbalancer EXTERNAL-IP:80
