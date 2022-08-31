# Third Party

In the first lab, we bootstrapped Terraform and got familiar with the very basics. Let’s extend the stack and add a simple *Hello World API*. We want to use [Amazon API Gateway](https://aws.amazon.com/api-gateway/) and [AWS Lambda](https://aws.amazon.com/lambda/) (with Node.js) for a serverless API returning a hello world statement.

## Lambda function

1. Create a new folder inside the project: `mkdir functions`
2. Create a new JS file: `touch functions/helloworld.js`
3. Add the following lines to the JS file:
  ```js
  exports.handler = async () => {
    return { 
      message: "Hello from Lambda! 👋"
    };
  };
  ```
4. Now, go back to the `main.tf` file and replace it with:
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

  module "lambda_function" {
    source = "terraform-aws-modules/lambda/aws"
    version = "3.2.0"

    function_name = "hello-world"
    handler       = "helloworld.handler"
    runtime       = "nodejs14.x"
    source_path   = "./functions"
  }
  ```
5. Run `terraform init`, then `terraform apply`, and confirm the changes with `yes`.
6. Go to the [Lambda console](https://eu-central-1.console.aws.amazon.com/lambda/home?region=eu-central-1#/functions/hello-world?tab=testing). You should see the deployed Lambda function. Now, scroll down a little bit and click on the `Test` button. Click on `Details`. You should see the output of the Lambda function:
  ```json
  {
    "message": "Hello from Lambda! 👋"
  }
  ```

So far, we used *resources* to describe AWS infrastructure. Think of it as a low-level component to describe one specific entity in AWS (like an IAM user or an S3 bucket). Sometimes we have a combination of resources widely used we would like to bundle into an abstraction layer. That’s where modules come in.

The good part is, that we can write our own modules or use third-party modules. In this case, we used a third-party module called [*terraform-aws-modules/lambda/aws*](https://registry.terraform.io/modules/terraform-aws-modules/lambda/aws/latest). So instead of wiring up many resources by ourselves to deploy a simple Lambda function, we can just use the module. It bundles the source code and handles the IAM policies in the background.

The Terraform community is very vibrant and you can find thousands of modules. Before reinventing the wheel, check out the [Terraform Registry](https://registry.terraform.io).

For third-party modules, it’s [good practice](https://www.terraform.io/language/expressions/version-constraints#module-versions) to add the version attribute and define a specific version. That ensures you don’t accidentally upgrade third-party modules.

That’s it for the Lambda function. Let’s go to the API Gateway.

## API Gateway

1. Replace the `main.tf` file with:
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

  module "lambda_function" {
    source  = "terraform-aws-modules/lambda/aws"
    version = "3.2.0"

    function_name = "hello-world"
    handler       = "helloworld.handler"
    runtime       = "nodejs14.x"
    source_path   = "./functions"

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
2. Replace the `outputs.tf` file:
  ```tf
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

The [next lab](../3-module-composition/) covers a very important topic: Instead of just deploying the stack once, we want to deploy the stack for multiple environments (e.g. staging and prod). Along the way, we discuss module composition and code splitting.
