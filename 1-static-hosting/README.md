# Static Hosting

Welcome to the first lab! 🥳 Let's get started by bootstrapping aTerraform and deploying some resources to AWS. Instead of just deploying some random resources, we want to create a S3 bucket and enable static website hosting. Ultimately, we serve a static HTML file.
  
## Bootstrap Terraform

1. Create a new folder and cd into it.
1. Create a new file `main.tf`
2. Add these lines to the `main.tf`:
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

  data "aws_caller_identity" "current" {}

  resource "aws_s3_bucket" "website" {
    bucket = "hello-world-website-${data.aws_caller_identity.current.account_id}"
    force_destroy = true
  }
  ```
5. Run `terraform apply` and confirm the deployment with `yes`.

We just created an empty S3 bucket. Go to the [S3 console](https://s3.console.aws.amazon.com/s3/buckets) and verify the existence. 

What's going on here? We created a simple `.tf` file: Terraform comes with its own syntax called [HCL](https://www.terraform.io/language/syntax/configuration). In the `main.tf` file, we set the required Terraform version. After that, we configure a provider. Throughout the workshop, we focus on AWS and only deploy AWS resources. The [AWS provider](https://www.terraform.io/language/providers) gives us all the resources and data sources we need to interact with AWS.

Bare in mind, that Terraform provides [dozens of providers](https://registry.terraform.io/browse/providers) (e.g. Azure, Google Cloud Plaform or even Auth0).

Now, after the provider we have a data source and a resource. The resource block describes a simple S3 bucket. The configuration arguments (between `{` and `}`) describe the resource furthermore. S3 buckets always need an unique bucket name. To achieve this, we get the current AWS account id and append it to the bucket name. We get the AWS account id by using the `aws_caller_identity` data source. With data sources, we can fetch data outside of the Terraform stack and use it for resources.

Finally, we run `terraform apply` to deploy the resources.

## Static hosting

Let's extend the stack and deploy more resources:

1. Create a new file `index.html` next to the `main.tf`:
2. Add the following lines to the HTML file:
  ```html
  <!DOCTYPE html>
  <html>
    <body>
      <h1>Hello World :)</h1>
    </body>
  </html>
  ```
3. Replace the `main.tf` file:
  ```tf
  terraform {
    required_version = "~> 1.1.7"
  }

  provider "aws" {
    region = "eu-west-1"
  }

  data "aws_caller_identity" "current" {}

  resource "aws_s3_bucket" "website" {
    bucket = "hello-world-website-${data.aws_caller_identity.current.account_id}"
    force_destroy = true
  }

  resource "aws_s3_object" "startpage" {
    bucket = aws_s3_bucket.website.id
    key    = "index.html"
    source = "index.html"
    acl = "public-read"
    content_type = "text/html"
  }

  resource "aws_s3_bucket_website_configuration" "website" {
    bucket = aws_s3_bucket.website.bucket

    index_document {
      suffix = "index.html"
    }
  }

  output "website_url" {
    description = "Static website URL"
    value = "http://${aws_s3_bucket_website_configuration.website.website_endpoint}"
  }
  ```
3. Run `terraform apply` again and confirm with `yes`.

The new resources enable static website hosting and upload the `index.html`. Feel free to go to the S3 console again. You should see the `index.html` file in the bucket.

We also introduced an output: Output is very helpful to retrieve certain data after deployment. Go back to the terminal and check the output. You should find something like this: 

```sh
Outputs:

website_url = "http://hello-world-website-XXXXXXXXXXX.s3-website-eu-west-1.amazonaws.com"
```

Thanks to the output, we can easily find the endpoint of the static website without navigating to the AWS management console. In addition, the output might be also interesting for automation (e.g. get the URL to run integration tests etc.).

## Next

That's it for the first lab. We learned some Terraform basics (provider, data sources, resources and outputs) and deployed some resources. In the [next lab](../2-simple-api/), we extend the stack and create a simple API.
