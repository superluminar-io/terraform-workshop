# Simple API

In the first lab, we bootstrapped Terraform and created some resources. Finally, we deployed the resources to AWS and got a very basic static website hosting. Pretty cool, huh? Let's extend the stack and add a simple *Hello World API*. We want to use [Amazon API Gateway](https://aws.amazon.com/api-gateway/) and [AWS Lambda](https://aws.amazon.com/lambda/) (with Node.js) for a very basic serverless API returning a hello world statement.

## Lambda function

1. Create a new folder inside the project: `mkdir functions`
2. Create a new JS file: `touch functions/helloworld.js`
3. Add the following lines to the JS file:
  ```js
  exports.handler = async () => {
    return { "message": process.env.RESPONSE };
  };
  ```
4. Now, go back to the `main.tf` file and replace it:
  ```tf
  terraform {
    required_version = "~> 1.1.7"
  }

  provider "aws" {
    region = "eu-west-1"
  }

  data "aws_caller_identity" "current" {}

  resource "aws_s3_bucket" "website" {
    bucket        = "hello-world-website-${data.aws_caller_identity.current.account_id}"
    force_destroy = true
  }

  resource "aws_s3_object" "startpage" {
    bucket       = aws_s3_bucket.website.id
    key          = "index.html"
    source       = "index.html"
    acl          = "public-read"
    content_type = "text/html"
  }

  resource "aws_s3_bucket_website_configuration" "website" {
    bucket = aws_s3_bucket.website.bucket

    index_document {
      suffix = "index.html"
    }
  }

  variable "lambda_function_response" {
    type        = string
    description = "Body response of the hello world lambda function"
    default     = "Hello from Lambda!"
  }

  module "lambda_function" {
    source = "terraform-aws-modules/lambda/aws"

    function_name = "hello-world"
    handler       = "helloworld.handler"
    runtime       = "nodejs12.x"
    source_path   = "./functions"
    environment_variables = {
      "RESPONSE" = var.lambda_function_response
    }
  }
  ```
5. Run `terraform init`, then `terraform apply` and confirm the changes with `yes`.
6. Go to the [Lambda console](https://eu-west-1.console.aws.amazon.com/lambda/home?region=eu-west-1#/functions/hello-world?tab=testing). You should see the deployed Lambda function. Now, scroll down a little bit and click on the `Test` button. Click on `Details`. You should see the output of the Lambda function:
  ```json
  {
    "message": "Hello from Lambda!"
  }
  ```

It's worth noting that we use environment variables to pass certain data to the Lambda function. The Terraform [input variable](https://www.terraform.io/language/values/variables) sets the response of the Lambda function. Feel free to play around with the default value and deploy the stack again. You should retrieve the new Lambda function response.

In addition, we also use a [module](https://www.terraform.io/language/modules/develop) for the first time. A *module* is a container for multiple resources. We use a third-party library called [*terraform-aws-modules/lambda/aws*](https://registry.terraform.io/modules/terraform-aws-modules/lambda/aws/latest) to describe a Lambda function. Essentially, the library does the heavy lifting for us. It bundles the function source code and uploads it to the public cloud. We could also use plain AWS resources and create the process by ourselves, but that's not good advice. Before reinventing the wheel, we should check for open-source modules already available. The [Terraform Registry](https://registry.terraform.io/) is a good starting point to find the right library.

So, the Lambda function is in place and we can go to the next component. The API Gateway sitting in front of the Lambda function and processing HTTP(S) requests.

## API Gateway

1. Replace the `main.tf` file:
  ```tf
  terraform {
    required_version = "~> 1.1.7"
  }

  provider "aws" {
    region = "eu-west-1"
  }

  data "aws_caller_identity" "current" {}

  resource "aws_s3_bucket" "website" {
    bucket        = "hello-world-website-${data.aws_caller_identity.current.account_id}"
    force_destroy = true
  }

  resource "aws_s3_object" "startpage" {
    bucket       = aws_s3_bucket.website.id
    key          = "index.html"
    source       = "index.html"
    acl          = "public-read"
    content_type = "text/html"
  }

  resource "aws_s3_bucket_website_configuration" "website" {
    bucket = aws_s3_bucket.website.bucket

    index_document {
      suffix = "index.html"
    }
  }

  variable "lambda_function_response" {
    type        = string
    description = "Body response of the hello world lambda function"
    default     = "Hello from Lambda!"
  }

  module "lambda_function" {
    source = "terraform-aws-modules/lambda/aws"

    function_name = "hello-world"
    handler       = "helloworld.handler"
    runtime       = "nodejs12.x"
    source_path   = "./functions"
    environment_variables = {
      "RESPONSE" = var.lambda_function_response
    }

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

  output "website_url" {
    description = "Static website URL"
    value       = "http://${aws_s3_bucket_website_configuration.website.website_endpoint}"
  }

  output "api_url" {
    description = "Hello World API URL"
    value       = aws_apigatewayv2_api.hello_world.api_endpoint
  }
  ```
2. Run `terraform apply` and confirm the changes with `yes`.
3. Take the `api_url` from the Terraform output and open the URL in a browser. You should see the JSON response.

Okay, nothing really special here. We extended the stack and introduced more resources. In the end, we have an AWS Lambda function and an API Gateway in place.

## Next

The Terraform file is already growing and growing. Let's talk about some naming conventions and code structure best practices [in the next lab](../3-code-structure/).
