# Static Hosting

## Goals
- Set up Terraform
- Create first resource and deploy it
  
## Step-by-step Guide

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

  resource "aws_s3_bucket" "website" {
    bucket = "superluminar-hello-world-website"
    force_destroy = true
  }
  ```
5. Run `terraform apply` and confirm the deployment with `yes`.

tbd
