#### Developers need a place to explore innovation and keep up with AWS services. This Terraform code sets up a sandbox environment for developers with some governance set by Ops such as: 
- IAM policy that does not limit any AWS Services but limits ec2 and rds instance types they can launch + AWS regions they can operate in. 
- SCP policies attached at the AWS Organizations level (code is present in this repo but scp is attached manually in master account)
- AWS Budget alarms 
- Lambda function that shuts off EC2 instances after 6pm CST 

Terraform Workspace is preconfigured at app.terraform.io 

