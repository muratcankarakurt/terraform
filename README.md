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

You can simply install these tools on macOS with Homebrew:
> brew install terraform awscli aws-iam-authenticator kubernetes-cli wget

After installing required tools you have to configure your AWS CLI. First you need to create a user named `terraform`. On AWS console, under Security, Identity, & Compliance menu, click IAM. Then click `Add user` and select `Programmatic Access` as the access type. On the next screen select `Attach existing policies directly` option on the top menu. Then search for `AdministratorAccess` and  `AmazonEKSClusterPolicy` policies and select them by clicking the box on the left side of each. You may skip tag adding and review screens. On the last screen, AWS will provide you the Access key ID and Secret access key. 

You may create below two files to complete AWS CLI configuration:
`~/.aws/credentials`
```
[default]
 aws_access_key_id=***********
 aws_secret_access_key=****************************
```
`~/.aws/config`
```
[default]
region=us-east-1
```
or try `aws configure` to complete it on the command line. You will see below screen:
```
AWS Access Key ID [None]: YOUR_AWS_ACCESS_KEY_ID
AWS Secret Access Key [None]: YOUR_AWS_SECRET_ACCESS_KEY
Default region name [None]: YOUR_AWS_REGION
Default output format [None]: json
```
