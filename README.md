# What we will achieve:

1.  Centralized Terraform State Management: Setting up an AWS S3 Bucket
    for Shared State Across Team Environments

2.  Run a web application in AWS VM using terraform

# Amazon S3

Store and retrieve any amount of data from anywhere

Amazon S3 (Simple Storage Service) in AWS offers a robust solution for
diverse storage needs. Its versatility makes it a cornerstone for
various use cases, such as serving as a reliable backup and restore
system, hosting static websites, distributing content globally through
integration with Amazon CloudFront, and acting as a central data lake
for analytics services

We will utilize S3 bucket to maintain terraform state for all team
members.

Project source code Github:
<https://github.com/hasanashik/terraform_aws/tree/main>

**Repository introduction:**

In *terraform_aws* directory we have 4 terraform files:

1.  backend.tf: S3 bucket terraform state maintanance

2.  instance.tf: Defines required resources of AWS

3.  providers.tf: Defines cloud provider

4.  vars.tf: Defines variables used in other terraform files.

Generating an RSA key with default settings:

We have to create a SSH key pair which will be used at time of creating
resources in AWS. To do so we need to run: ssh-keygen

This will create public and private key files.

**[Part 1 Steps:]{.underline}**

1.  **Create S3 bucket and directory in bucket**

2.  **Write backend.tf**

3.  **Terraform apply**

**Creating S3 bucket and directory in bucket:**

Go to: Amazon S3 \> Buckets \> Create bucket

Give a bucket name and click create bucket.

![](./images/image1.png)

Create Security group by adding inbound rules. For test purpose we are
allowing all HTTP, TCP connections for IPv4 and IPv6:

![](./images/image2.png)

Copy security gruoup ID to instance.tf file.

![](./images/image3.png)

Update AMI in var.tf as per your zone available AMI. Here we are using
Amazon Machine Image (AMI)

![](./images/image4.png)

![](./images/image5.png)

Now create a S3 bucket:

![](./images/image6.png)

![](./images/image7.png)

Create a repository inside bucket:

![](./images/image8.png)

Update backend.tf values.

![](./images/image9.png)

Update providers.tf file as per your access key or you can do *[aws
configure]{.underline}* in cli.

![](./images/image10.png)

![](./images/image11.png)

Now let us initialize terraform to create state file in the folder of S3
bucket.

Run *[terraform init]{.underline}* or *[terraform init
-reconfigure]{.underline}*

![](./images/image12.png)

Do terraform validate, fmt and plan

![](./images/image13.png)

And finaly terraform apply.

![](./images/image14.png)

In the bucket now we can see that the state is updated:

![](./images/image15.png)

**Part 2: Run a website inside AWS EC2 VM using terraform**

Our part 1 terraform scripts already pushed the required bash script to
run web application inside the VM. Now we should have our web
application running at public ip of VM.

In our case we needed to manually run the web.sh file after copying its
content to a new manual script file.

![](./images/image16.png)

![](./images/image17.png)

And finally got our application at VM public ip address.

![](./images/image18.png) 

Let's now discuss the terraform scripts:

**Vars.tf**: It defines variables that can be used provide a flexible
way to manage configuration parameters for infrastructure resources and
can be referenced. The REGION variable specifies the default AWS region
as \"us-east-1.\" The ZONE1 variable sets the default availability zone
to \"us-east-1a.\" The AMIS variable, of type map(any), holds Amazon
Machine Image (AMI) IDs, with a default value assigned for the
\"us-east-1\" region. Lastly, the USER variable defines the default
username for connecting to EC2 instances as \"ec2-user.\"

![](./images/image19.png) 

**Providers.tf:** Defines an AWS provider block. We have commented out
access and secret key because they are configured using aws configure
command.

![](./images/image20.png)

And finally, **instance.tf**: This file creates AWS key-pair and EC2
instance.

![](./images/image21.png)

The first resource, aws_key_pair, creates an SSH key pair named
\"my-key\" using the public key from the file \"my-key.pub.\" The second
resource, aws_instance, launches an EC2 instance named \"zaman-inst\" in
the specified AWS region. It uses the AMI ID from the AMIS variable
based on the chosen region, with instance type \"t2.micro\" and
availability zone from the ZONE1 variable. The instance is associated
with a security group and tagged with a name and project. Additionally,
the script provisions the instance by copying a local script
(\"web.sh\") to \"/tmp/web.sh\" on the remote instance and then executes
it using remote-exec provisioners. The connection block specifies the
SSH user, private key file, and host information for connecting to the
instance.
