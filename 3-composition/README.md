# Composition

The previous lab introduced a third-party module to easily deploy a Lambda function with multiple resources. In this lab, we want to create modules for the static website and the API. After that, we re-use the modules to describe a staging and production environment.

## Custom Modules

1. Delete the current stack by running `terraform destroy` and confirm with `yes`.
1. Create new folders:
  ```sh
  mkdir modules
  mkdir modules/api
  mkdir modules/website
  ```
2. Move the `functions` folder inside the `modules/api` folder:
  ```sh
  mv functions modules/api
  ```
3. Move the `index.html` file inside the `modules/website` folder:
  ```sh
  mv index.html modules/website
  ```
4. Create a `main.tf` file inside the `modules/api` folder:
  ```sh
  touch modules/api/main.tf
  ```
5. Add the following lines to the file:
  ```tf
  locals {
    project_name = "hello-world"
  }

  module "lambda_function" {
    source = "terraform-aws-modules/lambda/aws"

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
6. Create a `outputs.tf` file inside the `modules/api` folder:
  ```sh
  touch modules/api/outputs.tf
  ```
7. Add the following lines to the file:
  ```sh
  output "url" {
    description = "Hello World API URL"
    value       = aws_apigatewayv2_api.hello_world.api_endpoint
  }
  ```
8. Create a `variables.tf` file inside the `modules/api` folder:
  ```tf
  variable "environment" {
    type = string
    description = "Identifier for the environment (e.g. staging, development or prod)"
  }
  ```
10. Create a `main.tf` file inside the `modules/website` folder:
  ```sh
  touch modules/website/main.tf
  ```
11. Add the following lines to the file:
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
12. Create a `outputs.tf` file inside the `modules/website` folder:
  ```sh
  touch modules/website/outputs.tf
  ```
13. Add the following lines to the file:
  ```sh
  output "url" {
    value = "http://${aws_s3_bucket_website_configuration.website.website_endpoint}"
  }
  ```
14. Create a `variables.tf` file inside the `modules/website` folder:
  ```tf
  variable "environment" {
    type = string
    description = "Identifier for the environment (e.g. staging, development or prod)"
  }
  ```
15. Delete all old files on the root level:
  ```sh
  rm *
  ```

That might be very overwhelming and understanding the big picture at this point is not easy. Before we get into the details, let's quickly add the Terraform stack for a staging environment. 

## Staging Environment

1. Create a new folder:
  ```sh
  mkdir staging
  ```
2. Create a new file:
  ```sh
  touch staging/main.tf
  ```
3. Add the following lines:
  ```tf
  terraform {
    required_version = "~> 1.1.7"
  }

  provider "aws" {
    region = "eu-west-1"
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
4. Create a new file:
  ```sh
  touch staging/outputs.tf
  ```
5. Add the following lines:
  ```tf
  output "api_url" {
    description = "Hello World API URL"
    value       = module.api.url
  }

  output "website_url" {
    description = "Static Website URL"
    value       = module.website.url
  }
  ```
6. Cd into the `staging` folder:
  ```sh
  cd staging
  ```
7. Run `terraform init` and `terraform apply`. Confirm the deployment with `yes`.

You might have noticed that we took everything from the previous labs and introduced two modules. One module for the API, one module for the website. New is, that we also created *input variables*. With input variables in Terraform, we can define a public interface for modules. So far, we introduced a simple input variable to pass an environment identifier to the modules. We use the identifier to create unique names for AWS resources (like the S3 bucket name). 

The modules folder itself functions as a library. We need a Terraform stack wiring up the modules, configuring the input variables and connecting the dots essentially. Therefore, we created the `staging` folder. As you can see in the `main.tf` file inside the staging folder, we import our modules and configure the `environment` variable. That's all we have to do here as the core business logic lives now in re-usable modules.

So staging is live, why not deploy prod?

## Production Environment

Repeat all steps we did to create a staging environment. Instead of creating a `staging` folder, simply create a `prod` folder. Make sure you use another identifier for the `environment` input variable.

After all, you should have two environments running in your AWS account.

## Next

In the [next lab](../4-parameterization/), we want to introduce another input variable to deploy a new feature to the staging environment while the production environment shouldn't deliver the new upcoming feature.
