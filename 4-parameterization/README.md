# Parameterization

The API becomes more powerful in this lab, but we want to be careful and only roll out the feature to the staging environment. The production environment still serves the old behavior. What we essentially implement is a classic feature flag.

## Implement new feature

1. Go to the file `modules/api/variables.tf` and replace it:
  ```
  variable "environment" {
    type        = string
    description = "Identifier for the environment (e.g. staging, development or prod)"
  }

  variable "enable_greeting_feature" {
    type        = bool
    description = "Enable greeting feature"
    default     = false
  }
  ```
2. Go to the file `modules/api/main.tf` and replace it:
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
    environment_variables = {
      GREETING_ENABLED = "${var.enable_greeting_feature}"
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
    name          = "${local.project_name}-${var.environment}"
    protocol_type = "HTTP"
    target        = module.lambda_function.lambda_function_arn
  }
  ```
3. Go to the file `modules/api/functions/helloworld.js` and replace it:
  ```js
  const greetingEnabled = process.env.GREETING_ENABLED === "true";

  exports.handler = async (event) => {  
    let message = "Hello from Lambda! 👋";
    const name = event.queryStringParameters?.name;

    if (greetingEnabled && name) {
      message = `Hello ${name}! 👋`;
    }

    return { message };
  };
  ```

We extended the *API* module by introducing a new input variable `enable_greeting_feature`. The default is set to `false`, so we can't accidentally distribute the new feature. In the `main.tf` file, we simply pass the input variable down to the AWS Lambda function as an environment variable. Finally, in the Lambda function, we use the environment variable to flip on the new feature.

The new feature wouldn't appear after deployment (feel free to try it and deploy your staging and production environment). We need to configure the new input variable explicitly. Let's do it.

## Rollout

1. Go to the file `staging/main.tf` and replace it:
  ```tf
  terraform {
    required_version = "~> 1.1.7"

    backend "s3" {
      key    = "staging/terraform.tfstate"
      region = "eu-west-1"
    }
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

    environment             = "staging"
    enable_greeting_feature = true
  }
  ```
2. Cd into the `staging` folder and run `terraform apply`. Confirm with `yes`.
3. Open the API URL in the browser. You should still see this message:
  ```json
  {"message":"Hello from Lambda! 👋"}
  ```
4. Now, add the `name` query param to the URL, e.g.:
  ```
  https://XXXXXXXXXX.execute-api.eu-west-1.amazonaws.com/?name=alice
  ```
5. Here we go! The new feature works on staging.

With input variables, we can make modules configurable for different scenarios. In this case, we only want to deploy a new feature to the staging environment, but not to production. In practice, it's a common requirement to configure environments differently. For example, we want to configure provisioned capacities (like CPU or memory allocation), a global CDN or custom domains with SSL certificates.

## Final words

Well, that was the last lab for the Terraform workshop. We hope you enjoyed the workshop. If you want to learn more about Terraform and dive deeper, take a look at the [reading list](../README.md#📖-further-reading).

Cheers ✌️
