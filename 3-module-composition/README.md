# Module Composition

The previous lab introduced a third-party module to easily deploy a Lambda function with multiple resources. In this lab, we want to improve the growing codebase and create custom modules for the static website and the API.

## Custom Modules

1. Before we start with the refactoring, make sure you deleted the existing stack by running `terraform destroy`. Confirm the command with `yes`.
2. Create new folders:
  ```sh
  mkdir modules
  mkdir modules/api
  mkdir modules/website
  ```
3. Move the `functions` folder inside the `modules/api` folder:
  ```sh
  mv functions modules/api
  ```
4. Move the `index.html` file inside the `modules/website` folder:
  ```sh
  mv index.html modules/website
  ```
5. Create a `main.tf` file inside the `modules/api` folder:
  ```sh
  touch modules/api/main.tf
  ```
6. Add the following lines to the file:
  ```tf
  module "lambda_function" {
    source  = "terraform-aws-modules/lambda/aws"
    version = "3.2.0"

    function_name = "hello-world"
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
    name          = "hello-world"
    protocol_type = "HTTP"
    target        = module.lambda_function.lambda_function_arn
  }
  ```
7. Create a `outputs.tf` file inside the `modules/api` folder:
  ```sh
  touch modules/api/outputs.tf
  ```
8. Add the following lines to the file:
  ```sh
  output "url" {
    description = "Hello World API URL"
    value       = aws_apigatewayv2_api.hello_world.api_endpoint
  }
  ```
11. Create a `main.tf` file inside the `modules/website` folder:
  ```sh
  touch modules/website/main.tf
  ```
12. Add the following lines to the file:
  ```tf
  data "aws_caller_identity" "current" {}

  resource "aws_s3_bucket" "website" {
    bucket = "hello-world-website-${data.aws_caller_identity.current.account_id}"
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
13. Create a `outputs.tf` file inside the `modules/website` folder:
  ```sh
  touch modules/website/outputs.tf
  ```
14. Add the following lines to the file:
  ```sh
  output "url" {
    description = "Hello World Website URL"
    value       = "http://${aws_s3_bucket_website_configuration.website.website_endpoint}"
  }
  ```
17. Replace the root `main.tf` file:
  ```tf
  terraform {
    required_version = "~> 1.1.7"

    backend "s3" {
      key    = "terraform.tfstate"
      region = "eu-central-1"
    }
  }

  provider "aws" {
    region = "eu-central-1"
  }

  module "website" {
    source = "./modules/website"
  }

  module "api" {
    source = "./modules/api"
  }
  ```
18. Replace the root `outputs.tf` file:
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

Okay, that was a huge refactoring. Let's examine it and talk about it step-by-step. 

First of all, we created our first custom modules. As you can see, it always follows the same pattern. We created new folders and added a `main.tf` and `outputs.tf` file. We then split up the root module into two custom modules. Finally, we introduced the custom modules in the root module and updated the output values to retrieve the data from the modules.

The modules follow a domain-driven approach. Instead of introducing one custom module, we separate the infrastructure by specific domains. In our case, we have dedicated modules for the API and static website hosting. Small and domain-driven modules make it easy to maintain the codebase and improve the readability for humans. Try not to overthink your custom modules and avoid complex branching logic or for loops.

## Next

The modules shaped reusable components. In the [next lab](../4-multi-environment/), we use the modules to set up a staging and production environment. 
