# Multi Environment

With custom modules, we already have reusable components ready for a multi-environment setup. So far, we have always deployed one Terraform stack. In this lab, we want to further improve the codebase and deploy two stacks.

## Staging environment

1. Before we start with the refactoring, make sure you deleted the existing stack by running `terraform destroy`. Confirm the command with `yes`.
2. Create a `variables.tf` file inside the `modules/api` folder:
  ```sh
  touch modules/api/variables.tf
  ```
3. Add the following lines to the file:
  ```tf
  variable "environment" {
    type = string
    description = "Identifier for the environment (e.g. staging, development or prod)"
  }
  ```
4. Update the `modules/api/main.tf` file:
  ```tf
  locals {
    project_name = "hello-world"
  }

  module "lambda_function" {
    source  = "terraform-aws-modules/lambda/aws"
    version = "3.2.0"

    function_name = "${local.project_name}-${var.environment}"
    handler       = "helloworld.handler"
    runtime       = "nodejs14.x"
    source_path   = "${path.module}/functions"

    publish = true
    allowed_triggers = {
      AllowExecutionFromAPIGateway = {
        service    = "apigateway"
        source_arn = "${aws_apigatewayv2_api.hello_world.execution_arn}/*/*"
      }
    }
  }

  resource "aws_apigatewayv2_api" "hello_world" {
    name          = "${local.project_name}-${var.environment}"
    protocol_type = "HTTP"
    target        = module.lambda_function.lambda_function_arn
  }
  ```
5. Create a `variables.tf` file inside the `modules/website` folder:
  ```sh
  touch modules/website/variables.tf
  ```
6. Add the following lines to the file:
  ```tf
  variable "environment" {
    type = string
    description = "Identifier for the environment (e.g. staging, development or prod)"
  }
  ```
7. Update the `modules/website/main.tf` file:
  ```tf
  data "aws_caller_identity" "current" {}

  resource "aws_s3_bucket" "website" {
    bucket = "hello-world-website-${data.aws_caller_identity.current.account_id}-${var.environment}"
    force_destroy = true
  }

  resource "aws_s3_object" "startpage" {
    bucket       = aws_s3_bucket.website.id
    key          = "index.html"
    source       = "${path.module}/index.html"
    acl          = "public-read"
    content_type = "text/html"
  }

  resource "aws_s3_bucket_website_configuration" "website" {
    bucket = aws_s3_bucket.website.bucket

    index_document {
      suffix = "index.html"
    }
  }
  ```
7. Create a new `staging` folder:
  ```sh
  mkdir staging
  ```
8. Move the root module into the `staging` folder:
  ```
  mv main.tf outputs.tf .terraform.lock.hcl ./staging
  ```
9. Update the `staging/main.tf` file:
  ```tf
  terraform {
    required_version = "~> 1.1.7"

    backend "s3" {
      key    = "staging/terraform.tfstate"
      region = "eu-central-1"
    }
  }

  provider "aws" {
    region = "eu-central-1"
  }

  module "website" {
    source = "../modules/website"

    environment = "staging"
  }

  module "api" {
    source = "../modules/api"

    environment = "staging"
  }
  ```
10. Cd into the `staging` folder:
  ```sh
  cd staging
  ```
11. Run `terraform init`. Again, provide the S3 bucket name.
12. Run `terraform apply` and confirm the deployment with `yes`.

You might have noticed that we extended the modules and introduced so-called *input variables*. With input variables in Terraform, we can define a public interface for modules. We introduced a simple input variable to pass an environment identifier to the modules. The identifier is important to create unique names for AWS resources (like the S3 bucket name).

After that, we created the `staging` folder and moved the existing root module into the folder. We updated the `main.tf` file to configure the `environment` variable and also updated the remote backend. The remote backend has a new key to create a dedicated and separated Terraform state just for the staging environment.

So staging is live, why not deploy prod?

## Production Environment

Repeat all steps we did to create a staging environment. Instead of creating a `staging` folder, simply create a `prod` folder. Make sure you use another identifier for the `environment` input variable. Also, update the bucket key for the remote backend: 

```tf
backend "s3" {
  key    = "prod/terraform.tfstate"
  region = "eu-central-1"
}
```

After all, you should have two environments running in your AWS account.

## Next

In the [next lab](../5-parameterization/), we want to introduce another input variable to deploy a new feature to the staging environment while the production environment shouldn’t deliver the new upcoming feature.
