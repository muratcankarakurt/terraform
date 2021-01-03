# Create an EKS Cluster and a Jenkins Server with Terraform and Helm

This tutorial includes terraform scripts to deploy an EKS cluster with worker nodes in EC2. Deploys a Jenkins Server on EKS using Jenkins Helm Chart.

> Assuming that you have accounts on Github, DockerHub and AWS.

## Prerequisites

Following tools must be installed on your environment:
- Terraform
- AWS CLI
- AWS IAM Authenticator
- kubectl
- wget
- helm

You can simply install these tools on macOS with Homebrew:
> brew install terraform awscli aws-iam-authenticator kubernetes-cli wget helm

After installing required tools you have to configure your AWS CLI. First you need to create a user named `terraform`. On AWS console, under Security, Identity, & Compliance menu, select IAM. 
- Then click `Add user` and select `Programmatic Access` as the access type. 
- On the next screen select `Attach existing policies directly` option on the top menu. Then search for `AdministratorAccess` and  `AmazonEKSClusterPolicy` policies and select them by clicking the box on the left side of each. 
- You may skip tag adding and review screens. 
- On the last screen, AWS will provide you the Access key ID and Secret access key. 

You may create below two files to complete AWS CLI configuration:

`~/.aws/credentials`:
```
[default]
 aws_access_key_id=*****
 aws_secret_access_key=********
```
`~/.aws/config`:
```
[default]
region=us-east-1
```
or try `aws configure` to complete it on the command line interactively.
```console
AWS Access Key ID [None]: YOUR_AWS_ACCESS_KEY_ID
AWS Secret Access Key [None]: YOUR_AWS_SECRET_ACCESS_KEY
Default region name [None]: YOUR_AWS_REGION
Default output format [None]: json
```

## Setting up Terraform workspace

I have followed up official tutorials of HashiCorp. Here is the link for the external documentations and scripts:

[Provision an EKS Cluster (AWS)](https://learn.hashicorp.com/tutorials/terraform/eks)

[Scripts in Hashicorp's github repo](https://github.com/hashicorp/learn-terraform-provision-eks-cluster)

```console
git clone https://github.com/muratcankarakurt/terraform.git
cd terraform
```

`eks-cluster.tf` You can configure your cluster_version, tags, instance_types and how many ec2 instances you want.

`vpc.tf` You can change the VPC configuration. By default, this tutorial creates a VPC with 10.0.0.0/16 network.

`jenkins.tf` This file creates Jenkins server on EKS with the desired configurations. You may also customize this one.

`outputs.tf` You can customize the output of terraform script in this file. For example I have added the jenkins admin password in the output.

Run the following commands to create your EKS Cluster:
```console
# Initializing terraform workspace and downloading required providers.
terraform init
# Applying changes on AWS.
terraform apply
```
>You will be prompted to approve terraform apply command. Type `yes`

>This operation may take about 10-15 mins.

## Logging into Jenkins on EKS

After the script completes running, you will see an output of terraform. Copy the value of `jenkins_password` from the output. You can find your public address from AWS Console following these steps:
- Select `EC2` under Compute menu.
- From the left menu, select `Load Balancers` under Load Balancing
- Cilck the related load balancer. You will find the `DNS name` in the Basic Configuration section.

Type `http://<YOUR_LOADBALANCER_ADDRESS>:8080` in browser. Use `admin` as the user and the password from the terraform output.

Happy automating!

## Cleanup the playground
Do not forget to delete AWS resources. You will be ```charged``` for this configurations. To delete all the resources you have created run the following command:
```console
terraform destroy
```

## Issues and Errors

>You might have an issue with aws-auth config map while running terraform destroy command. You may simply delete configmap block in terraform.state file and re-run terraform destroy.

`Error: Delete "http://localhost/api/v1/namespaces/kube-system/configmaps/aws-auth": dial tcp [::1]:80: connect: connection refused`

>Some resources on AWS cannot be deleted sometimes. You can delete them manually from AWS and re-run destroy command. I had this issue with ELB, Internet Gateway and VPC.

## Play with Jenkins

If you want to do some `CI/CD` operations on Jenkins that you recently set up, you may check my `sampletomcat` repo. Find the link in the bottom of the page.

Before you go run this command to use helm effectively in Jenkins. That will create a service account named `helm` and grants required permissions.

```console
kubectl apply -f helm-user-rbac.yaml
```

## Next: [Deploying a Sample Application on EKS using Jenkins and Helm](https://github.com/muratcankarakurt/sampletomcat)
