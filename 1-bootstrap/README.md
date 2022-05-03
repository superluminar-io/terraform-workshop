# Bootstrap

## Goals
- Set up Terraform
- Create first resource and deploy it
- Understand data sources
  
## Step-by-step Guide

### Deploy first resource

Let's get started by setting up Terraform and deploy the first resource.

1. Create a new file `main.tf`
2. Set Terraform version and AWS provider: 
  ```tf
  terraform {
    required_version = "~> 1.1.7"
  }

  provider "aws" {
    region = "eu-west-1"
  }
  ```
3. Run `terraform init`
4. Add the first resource:
  ```tf
  terraform {
    required_version = "~> 1.1.7"
  }

  provider "aws" {
    region = "eu-west-1"
  }

  resource "aws_iam_user" "ci" {
    name = "CI"
  }
  ```
5. Run `terraform apply` and confirm the deployment with `yes`.

### Use data sources

Cool, we just deployed our first resource with Terraform. 🎉 It's just an IAM user but it's something. This simple IAM user could be already helpful in deploying the Terraform stack in a CI pipeline later on. Now, let's extend the IAM user and attach an IAM policy. 

1. Go to the `main.tf` and replace it:
  ```tf
  terraform {
    required_version = "~> 1.1.7"
  }

  provider "aws" {
    region = "eu-west-1"
  }

  data "aws_iam_policy" "admin" {
    name = "AdministratorAccess"
  }

  resource "aws_iam_user" "ci" {
    name = "CI"
  }

  resource "aws_iam_user_policy_attachment" "ci" {
    user       = aws_iam_user.ci.name
    policy_arn = data.aws_iam_policy.admin.arn
  }
  ```
2. Run `terraform apply` and confirm the deployment with `yes`.

Okay, we introduced a new resource to attach a policy to the user and used a [data source](https://www.terraform.io/language/data-sources). What is it? Essentially, we can fetch data outside of Terraform and use it inside the stack. In this case, we fetch the managed policy by the name (`AdministratorAccess`) and get the policy ARN. We can then use the policy ARN for the policy attachment.
